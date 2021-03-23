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
@clean
set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
drop tablespace demo including contents and datafiles;
drop table t99 purge;
set termout on
set echo on
clear screen
create tablespace DEMO
datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO.DBF' size 10m autoextend on next 1m;
pause

create table t99 tablespace demo as
select d.* from dba_objects d,
( select 1 from dual connect by level <= 25 );
pause
clear screen
select bytes/1024/1024
from   user_segments
where  segment_name = 'T99';
pause
clear screen
select bytes/1024/1024 from dba_data_files
where tablespace_name = 'DEMO';
pause
alter table t99 move;
pause
select bytes/1024/1024 from dba_data_files
where tablespace_name = 'DEMO';
pause
select bytes/1024/1024
from   user_segments
where  segment_name = 'T99';
pause
clear screen
drop tablespace demo including contents and datafiles;
create tablespace DEMO
datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO.DBF' size 10m autoextend on next 1m;
pause
create table t99 tablespace demo as
select d.* from dba_objects d,
( select 1 from dual connect by level <= 25 );
pause
clear screen
select bytes/1024/1024
from   user_segments
where  segment_name = 'T99';
pause
select bytes/1024/1024 from dba_data_files
where tablespace_name = 'DEMO';
pause
alter table t99 move compress;
pause
select bytes/1024/1024 from dba_data_files
where tablespace_name = 'DEMO';
pause
select bytes/1024/1024
from   user_segments
where  segment_name = 'T99';
pause
clear screen
drop tablespace demo including contents and datafiles;
create tablespace DEMO
datafile 'X:\ORACLE\ORADATA\DB19\PDB1\DEMO.DBF' size 10m autoextend on next 1m;
create table t99 tablespace demo as
select d.* from dba_objects d,
( select 1 from dual connect by level <= 25 );
pause
clear screen
select bytes/1024/1024
from   user_segments
where  segment_name = 'T99';
pause
select bytes/1024/1024 from dba_data_files
where tablespace_name = 'DEMO';
pause
alter table t99 move online;
pause
select bytes/1024/1024 from dba_data_files
where tablespace_name = 'DEMO';
pause
select bytes/1024/1024
from   user_segments
where  segment_name = 'T99';
pause
set echo off
pro Get second session ready to do it again
pro Press enter to go
pause
set echo on
clear screen
alter table t99 move online;
