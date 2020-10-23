REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@clean
set termout off
conn USER/PASSWORD@MY_DB
set termout off
clear screen
@drop t1
@drop t2

set define '&'
set feedback on

clear screen
set echo on
set  autotrace off
set timing off
set linesize 2000
set termout on


create table t1 NOLOGGING as 
select object_name,object_id,owner 
from dba_objects 
where object_id<10;
pause

clear screen
set autotrace traceonly statistics
insert/*+ append */ into t1 
select object_name,object_id,owner 
from dba_objects 
where object_id>10 and object_id<20;
set autotrace off
commit;
pause
clear screen

create table t2 LOGGING as 
select object_name,object_id,owner 
from dba_objects 
where object_id<10;
pause

set autotrace traceonly statistics
insert into t2 
select object_name,object_id,owner 
from dba_objects 
where object_id>10 and object_id<20;
commit;
pause
set  autotrace off
clear screen

drop table t1 purge;
drop table t2 purge;

create table t1 NOLOGGING as 
select object_name,object_id,owner 
from dba_objects 
where object_id<10;

create table t2 LOGGING as 
select object_name,object_id,owner 
from dba_objects 
where object_id<10;
pause
clear screen

set autotrace traceonly statistics
insert/*+ append */ into t1 select object_name,object_id,owner from dba_objects;
commit;
set autotrace off
pause

set autotrace traceonly statistics
insert into t2 select object_name,object_id,owner from dba_objects;
commit;
set autotrace off
pause

clear screen
truncate table t1;
truncate table t2;

create index t1_idx1 on t1(object_id);
create index t1_idx2 on t1(object_name);

create index t2_idx1 on t2(object_id);
create index t2_idx2 on t2(object_name);
pause
clear screen

set autotrace traceonly statistics
insert/*+ append */ into t1 select object_name,object_id,owner from dba_objects;
commit;
set autotrace off
pause

set autotrace traceonly statistics
insert into t2 select object_name,object_id,owner from dba_objects;
commit;
set autotrace off
pause

clear screen
drop table t2 purge;

create table t2 LOGGING as 
select object_name,object_id,owner 
from dba_objects 
where object_id<10;
pause

set termout off
clear screen
conn USER/PASSWORD@MY_DB
set termout on
set echo on

set autotrace traceonly statistics
insert into t2 
select object_name,object_id,owner 
from dba_objects 
where object_id>10 and object_id<20;
commit;
set autotrace off
pause

select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name like 'IMU%';

