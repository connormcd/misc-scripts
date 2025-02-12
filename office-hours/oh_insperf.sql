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
conn USER/PASSWORD@MY_PDB
set termout off
set timing off
@drop t
REM @dropc t_source
REM create tablespace dspace datafile 'D:\ORACLE\ORADATA\DB19\PDB1\DSPACE.DBF' size 2g
REM extent management local uniform size 32m;
REM create table t_source tablespace largets nologging pctfree 0
REM as select d.* from dba_objects d,
REM   ( select 1 from dual connect by level <= 50 );
alter tablespace dspace nologging;
alter user myuser default tablespace dspace;
drop table t purge;
set termout on
clear screen
set echo on
REM create table t_source 
REM as select d.* from dba_objects d,
REM   ( select 1 from dual connect by level <= 50 );
pause
select num_rows, blocks
from   user_tables
where  table_name = 'T_SOURCE';
pause
create table t 
as select * from dba_objects where 1=0;
pause
set echo off
clear screen
alter user myuser default tablespace users;
clear screen
set echo on
set timing on  
insert /*+ APPEND */ into t
select * from t_source;
set timing off
commit;
pause
set lines 70
desc t

