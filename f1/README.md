# Formula 1 data

1) Copy files into a common directory.  Assumes you have access to CURL, GZIP and SED utilties.
2) Run f1.sh, which will download the F1 data, unzip it and convert it from non-Oracle to an Oracle script called f1_build.sql
3) Run f1_wrapper.sql in a precreated schema you wish to load the tables into. This will call f1_build.sql to load the tables

Standard disclaimer - anything in here can be used at your own risk.

No warranty or liability etc etc etc. See the license.
