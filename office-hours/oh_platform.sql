REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
set echo on
connect / as sysdba
pause
select platform_name from v$database;
pause
shutdown abort
pause
host dir X:\oracle\oradata\DB19S
pause
host del /q X:\oracle\oradata\DB19S\*.*
pause
host dir X:\oracle\oradata\DB19S
pause
host cat c:\oracle\sql\oh_platform_rman_bkp.txt
pause
host dir X:\temp\bkp*
pause
startup nomount
pause
clear screen
host rman target / @c:\oracle\sql\oh_restore.rman
pause
host dir X:\oracle\oradata\DB19S
pause
clear screen
create controlfile set database "DB19S" resetlogs  noarchivelog
    maxlogfiles 16
    maxlogmembers 3
    maxdatafiles 100
    maxinstances 8
    maxloghistory 292
logfile
  group 1 'X:\ORACLE\ORADATA\DB19S\REDO01.LOG'  size 200m blocksize 512,
  group 2 'X:\ORACLE\ORADATA\DB19S\REDO02.LOG'  size 200m blocksize 512,
  group 3 'X:\ORACLE\ORADATA\DB19S\REDO03.LOG'  size 200m blocksize 512
datafile
  'X:\ORACLE\ORADATA\DB19S\SYSTEM01.DBF',
  'X:\ORACLE\ORADATA\DB19S\SYSAUX01.DBF',
  'X:\ORACLE\ORADATA\DB19S\UNDOTBS01.DBF',
  'X:\ORACLE\ORADATA\DB19S\USERS01.DBF'
character set al32utf8;
pause
alter database open resetlogs;
pause
alter tablespace temp 
add tempfile 'X:\ORACLE\ORADATA\DB19S\TEMP01.DBF' size 1g autoextend on;
pause
connect SYSTEM_USER/PASSWORD
pause
select * from dual;
pause
exit