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
set lines 100
set serverout off
alter system flush shared_pool;
REM
REM create temporary tablespace temp_small tempfile 'X:\ORACLE\ORADATA\DB19\PDB1\TEMP_SMALL.DBF' size 1000m;
REM
alter user USERNAME temporary tablespace temp;
alter session set workarea_size_policy = manual;
alter session set sort_area_size = 48000000;
alter session set sort_area_retained_size = 48000000;

REM @drop t1x
REM @drop t2x

REM create table t1x tablespace largets pctfree 0 nologging as
REM select
REM  rownum pk
REM ,owner
REM ,object_name
REM ,subobject_name
REM ,object_id
REM ,data_object_id
REM ,object_type
REM ,created
REM ,last_ddl_time
REM from dba_objects,
REM   ( select 1 from dual connect by level <= 100 );
REM 
REM create table t2x tablespace largets pctfree 0 nologging 
REM as select
REM  pk
REM ,owner
REM ,object_name
REM ,subobject_name
REM ,case when rownum != 6123123 then object_id else 0 end object_id
REM ,data_object_id
REM ,case when rownum != 123123 then object_type else 'x' end object_type
REM ,created
REM ,last_ddl_time
REM from t1x
REM where mod(pk,3843212)!= 0;

set termout on
set echo off
clear screen

pro | create table t1x as
pro | select
pro |  rownum pk
pro | ,owner
pro | ,object_name
pro | ,subobject_name
pro | ,object_id
pro | ,data_object_id
pro | ,object_type
pro | ,created
pro | ,last_ddl_time
pro | from dba_objects,
pro |   ( select 1 from dual connect by level <= 100 );
pro | 
pro | create table t2x as
pro | select
pro |  pk
pro | ,owner
pro | ,object_name
pro | ,subobject_name
pro | ,case when rownum != 6123123 then object_id else 0 end object_id
pro | ,data_object_id
pro | ,case when rownum != 123123 then object_type else 'x' end object_type
pro | ,created
pro | ,last_ddl_time
pro | from t1x
pro | where mod(pk,3843212)!= 0;
pause

set echo on 
clear screen
select num_rows, blocks
from   user_tables
where  table_name in ('T1X','T2X');
pause

set timing on
select * from 
(
  (
  select * from t1x
  minus
  select * from t2x
  )
  union all
  (
  select * from t2x
  minus
  select * from t1x
  )
);
pause
select * from dbms_xplan.display_cursor();
pause
clear screen

select t1x.pk, t2x.pk
from   t1x full outer join  t2x
on (t1x.pk = t2x.pk )
where t1x.pk is null
 or   t2x.pk is null
 or   t1x.owner         !=t2x.owner 
 or   t1x.object_name   !=t2x.object_name 
 or   t1x.subobject_name!=t2x.subobject_name 
 or   t1x.object_id     !=t2x.object_id 
 or   t1x.data_object_id!=t2x.data_object_id 
 or   t1x.object_type   !=t2x.object_type 
 or   t1x.created       !=t2x.created 
 or   t1x.last_ddl_time !=t2x.last_ddl_time 
#pause 
   or ( t1x.owner is null and t2x.owner is not null ) 
   or ( t1x.owner is not null and t2x.owner is null )
   or ( t1x.object_name is null and t2x.object_name is not null ) 
   or ( t1x.object_name is not null and t2x.object_name is null )
   or ( t1x.subobject_name is null and t2x.subobject_name is not null ) 
   or ( t1x.subobject_name is not null and t2x.subobject_name is null )
   or ( t1x.object_id is null and t2x.object_id is not null ) 
   or ( t1x.object_id is not null and t2x.object_id is null )
   or ( t1x.data_object_id is null and t2x.data_object_id is not null ) 
   or ( t1x.data_object_id is not null and t2x.data_object_id is null )
   or ( t1x.object_type is null and t2x.object_type is not null ) 
   or ( t1x.object_type is not null and t2x.object_type is null )
   or ( t1x.created is null and t2x.created is not null ) 
   or ( t1x.created is not null and t2x.created is null )
   or ( t1x.last_ddl_time is null and t2x.last_ddl_time is not null ) 
   or ( t1x.last_ddl_time is not null and t2x.last_ddl_time is null )

pause
/
pause
select * from dbms_xplan.display_cursor();
pause

clear screen
select t1x.pk, t2x.pk
from   t1x full outer join  t2x
on (t1x.pk = t2x.pk )
where t1x.pk is null
 or t2x.pk is null
 or nvl(t1x.owner,'x')                       !=nvl(t2x.owner,'x') 
 or nvl(t1x.object_name,'x')                 !=nvl(t2x.object_name,'x')
 or nvl(t1x.subobject_name,'x')              !=nvl(t2x.subobject_name,'x')
 or nvl(t1x.object_id,-1)                    !=nvl(t2x.object_id,-1)
 or nvl(t1x.data_object_id,-1)               !=nvl(t2x.data_object_id,-1)
 or nvl(t1x.object_type,'x')                 !=nvl(t2x.object_type,'x')
 or nvl(t1x.created, date '1900-01-01')      !=nvl(t2x.created, date '1900-01-01')
 or nvl(t1x.last_ddl_time, date '1900-01-01')!=nvl(t2x.last_ddl_time, date '1900-01-01');
pause
clear screen
select t1x.pk, t2x.pk
from   t1x full outer join  t2x
on (t1x.pk = t2x.pk )
where t1x.pk is null
 or t2x.pk is null
 or sys_op_map_nonnull(t1x.owner)         !=sys_op_map_nonnull(t2x.owner) 
 or sys_op_map_nonnull(t1x.object_name)   !=sys_op_map_nonnull(t2x.object_name)
 or sys_op_map_nonnull(t1x.subobject_name)!=sys_op_map_nonnull(t2x.subobject_name)
 or sys_op_map_nonnull(t1x.object_id)     !=sys_op_map_nonnull(t2x.object_id)
 or sys_op_map_nonnull(t1x.data_object_id)!=sys_op_map_nonnull(t2x.data_object_id)
 or sys_op_map_nonnull(t1x.object_type)   !=sys_op_map_nonnull(t2x.object_type)
 or sys_op_map_nonnull(t1x.created)       !=sys_op_map_nonnull(t2x.created)
 or sys_op_map_nonnull(t1x.last_ddl_time) !=sys_op_map_nonnull(t2x.last_ddl_time);
pause
clear screen
select t1x.pk, t2x.pk
from   t1x full outer join t2x
on (t1x.pk = t2x.pk )
where t1x.pk is null
 or t2x.pk is null
 or decode(t1x.owner,t2x.owner,1,0)                  =0
 or decode(t1x.object_name,t2x.object_name,1,0)      =0
 or decode(t1x.subobject_name,t2x.subobject_name,1,0)=0
 or decode(t1x.object_id,t2x.object_id,1,0)          =0
 or decode(t1x.data_object_id,t2x.data_object_id,1,0)=0
 or decode(t1x.object_type,t2x.object_type,1,0)      =0
 or decode(t1x.created,t2x.created,1,0)              =0
 or decode(t1x.last_ddl_time,t2x.last_ddl_time,1,0)  =0;
pause
clear screen
alter user USERNAME temporary tablespace temp_small;
pause
select t1x.pk, t2x.pk
from   t1x full outer join t2x
on (t1x.pk = t2x.pk )
where t1x.pk is null
 or t2x.pk is null
 or decode(t1x.owner,t2x.owner,1,0)                  =0
 or decode(t1x.object_name,t2x.object_name,1,0)      =0
 or decode(t1x.subobject_name,t2x.subobject_name,1,0)=0
 or decode(t1x.object_id,t2x.object_id,1,0)          =0
 or decode(t1x.data_object_id,t2x.data_object_id,1,0)=0
 or decode(t1x.object_type,t2x.object_type,1,0)      =0
 or decode(t1x.created,t2x.created,1,0)              =0
 or decode(t1x.last_ddl_time,t2x.last_ddl_time,1,0)  =0;
pause
clear screen
set autotrace on stat
pause
with
  t1y as ( select * from t1x where pk between 1 and 1000000 ),
  t2y as ( select * from t2x where pk between 1 and 1000000 )
select t1y.pk, t2y.pk
from   t1y full outer join  t2y
on (t1y.pk = t2y.pk )
where t1y.pk is null
 or t2y.pk is null
 or decode(t1y.owner,t2y.owner,1,0)                  =0
 or decode(t1y.object_name,t2y.object_name,1,0)      =0
 or decode(t1y.subobject_name,t2y.subobject_name,1,0)=0
 or decode(t1y.object_id,t2y.object_id,1,0)          =0
 or decode(t1y.data_object_id,t2y.data_object_id,1,0)=0
 or decode(t1y.object_type,t2y.object_type,1,0)      =0
 or decode(t1y.created,t2y.created,1,0)              =0
 or decode(t1y.last_ddl_time,t2y.last_ddl_time,1,0)  =0

pause
/
pause
clear screen
with
  t1y as ( select * from t1x where pk between 1 and 3000000 ),
  t2y as ( select * from t2x where pk between 1 and 3000000 )
select t1y.pk, t2y.pk
from   t1y full outer join  t2y
on (t1y.pk = t2y.pk )
where t1y.pk is null
 or t2y.pk is null
 or decode(t1y.owner,t2y.owner,1,0)                  =0
 or decode(t1y.object_name,t2y.object_name,1,0)      =0
 or decode(t1y.subobject_name,t2y.subobject_name,1,0)=0
 or decode(t1y.object_id,t2y.object_id,1,0)          =0
 or decode(t1y.data_object_id,t2y.data_object_id,1,0)=0
 or decode(t1y.object_type,t2y.object_type,1,0)      =0
 or decode(t1y.created,t2y.created,1,0)              =0
 or decode(t1y.last_ddl_time,t2y.last_ddl_time,1,0)  =0;
pause
clear screen

with
  t1y as ( select * from t1x where pk between 1 and 6000000 ),
  t2y as ( select * from t2x where pk between 1 and 6000000 )
select t1y.pk, t2y.pk
from   t1y full outer join  t2y
on (t1y.pk = t2y.pk )
where t1y.pk is null
 or t2y.pk is null
 or decode(t1y.owner,t2y.owner,1,0)                  =0
 or decode(t1y.object_name,t2y.object_name,1,0)      =0
 or decode(t1y.subobject_name,t2y.subobject_name,1,0)=0
 or decode(t1y.object_id,t2y.object_id,1,0)          =0
 or decode(t1y.data_object_id,t2y.data_object_id,1,0)=0
 or decode(t1y.object_type,t2y.object_type,1,0)      =0
 or decode(t1y.created,t2y.created,1,0)              =0
 or decode(t1y.last_ddl_time,t2y.last_ddl_time,1,0)  =0;
pause

alter user USERNAME temporary tablespace temp;
alter session set workarea_size_policy = auto;

