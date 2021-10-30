#!/bin/ksh

#
# Standard disclaimer - anything in here can be used at your own risk.
#
# edit the first three variables for your environment
#
# No warranty or liability etc etc etc. See the license file in the git repo root
#
# USE AT YOUR OWN RISK 
#

tmpdir=/tmp
tmpfile=sqlcl-latest.zip
target=/u01/app/oracle/product

if [ ! -d $target ] ; then
  echo "Fail on the target: $target"
  exit 1
fi

if [ ! -d $tmp ] ; then
  echo "Fail on the tmp: $tmp"
  exit 1
fi

GetLatest()
{
  cd $tmpdir
  rm -f $tmpfile 
  rm -rf sqlcl
  curl -s -o $tmpfile https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip
  if [ -f $tmpfile ] ; then
    unzip -q $tmpfile
    if [ ! -d sqlcl ] ; then
      echo "Drama unzipping the zip"
      exit 1
    fi
  else
    echo "Drama downloading the zip"
    exit
  fi
}

if [ -d $target/sqlcl ] ; then
  echo SQLCL already present. Checking version
  curver=`$target/sqlcl/bin/sql -version 2>/dev/null | grep Production | awk '{print $NF}'`
  case "x$curver" in
    x*.*) echo "Current version is: $curver"
          ;;
    *) echo "Got unexpected value for curver: $curver"
       exit 1
       ;;
  esac
  echo Getting version for latest on oracle site
  GetLatest
  cd $tmpdir
  latestver=`sqlcl/bin/sql -version 2>/dev/null | grep Production | awk '{print $NF}'`
  case "x$latestver" in
    x$curver) echo "Latest = current, no work to do"
              exit 0
              ;;
    x*.*) echo "Latest version is: $latestver, installing over existing"
          cd $target
          mv sqlcl sqlcl.$curver
          unzip -q $tmpdir/$tmpfile
          if [ -d sqlcl ] ; then
            echo "SQLCL upgrade to $latestver, old version in directory sqlcl.$curver"
            exit 0
          else
            echo "Drama unzipping the zip"
          fi
          ;;
    *) echo "Got unexpected value for latest version: $latestver"
       exit 1
       ;;
  esac
else
  echo No SQLCL found. Grabbing latest
  GetLatest
  cd $target
  unzip -q $tmpdir/$tmpfile
  if [ -d sqlcl ] ; then
    newver=`sqlcl/bin/sql -version 2>/dev/null | grep Production | awk '{print $NF}'`
    case "x$newver" in
      x*.*) echo "SQLCL version $newver installed"
            exit 0
            ;;
      *) echo "Could not get a version ($newver) for SQLCL. Check installation before using"
         exit 1
         ;;
    esac
  else
    echo "Drama unzipping the zip"
  fi
fi
