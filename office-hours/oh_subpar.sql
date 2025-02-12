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
col subobject_name format a15
col object_name format a15
@drop t
set termout on
clear screen
set echo on
create table t ( x int, y int );
pause
create index ix on t (x);
pause
insert into t values (1,1);
insert into t values (1,2);
insert into t values (1,3);
insert into t values (1,4);
pause
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
pause
clear screen
select object_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
alter index ix unusable;
pause
select object_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
alter index ix rebuild;
pause
select object_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
clear screen
drop table t purge;
pause
create table t ( x int, y int )
partition by list ( x )
(
  partition p1 values (1),
  partition p2 values (2)
);
pause
create index ix on t (x) local;
pause
insert into t values (1,1);
insert into t values (1,2);
insert into t values (1,3);
insert into t values (1,4);
pause
clear screen
select object_name, subobject_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
alter index ix modify partition p1 unusable;
pause
select object_name, subobject_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
alter index ix rebuild partition p1;
pause
select object_name, subobject_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
clear screen
drop table t purge;
create table t ( x int, y int )
partition by list ( x )
subpartition by hash ( y ) 
(
  partition p1 values (1)
    ( subpartition p1a, 
      subpartition p1b )
);
create index ix on t ( x,y) local;
pause
insert into t values (1,1);
insert into t values (1,2);
insert into t values (1,3);
insert into t values (1,4);
pause
clear screen
select object_name, subobject_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
alter index ix modify subpartition p1a unusable;
pause
select object_name, subobject_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
pause
alter index ix rebuild subpartition p1a;
pause
select object_name, subobject_name, last_ddl_time
from user_objects
where object_name in ('T','IX');
