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
clear screen
set timing off
set time off
@drop t
@drop t1
@drop seq
col partition_name format a20
col high_value format a30
set pages 999
set termout on
clear screen
set echo on
create table t
partition by list ( owner) automatic
( partition p1 values ('SYS' ))
as select * from dba_objects;
pause
select partition_name, high_value
from   user_tab_partitions
where  table_name = 'T'
and    rownum <= 10;
pause
clear screen
create index t_ix1 on t ( object_name);
create index t_ix2 on t ( object_id);
pause
select count(*) from t;
pause
clear screen
alter table t modify 
partition by list ( owner)
( partition everything values (default )
) 
#pause
update indexes 
( t_ix1 local,
  t_ix2 local )
online

pause
/
pause
select partition_name, high_value
from   user_tab_partitions
where  table_name = 'T';
pause
clear screen
create table t1 
for exchange with table t;
pause
create index t1_ix1 on t1 ( object_name);
create index t1_ix2 on t1 ( object_id);
pause
alter table t exchange 
 partition everything 
 with table t1 including indexes;
pause
select count(*) from t1;
pause
select count(*) from t;
pause
