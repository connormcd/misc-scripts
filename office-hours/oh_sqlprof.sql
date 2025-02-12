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
set pages 999
@drop t
exec dbms_sqltune.drop_tuning_task (task_name => 'my_tuning_task');
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t as 
select 
   owner
  ,object_name
  ,subobject_name
  ,object_id
  ,data_object_id
  ,object_type
  ,created
  ,last_ddl_time 
from dba_objects;
pause
clear screen
insert into t
select 
   owner
  ,'YYYY'
  ,subobject_name
  ,999999
  ,data_object_id
  ,object_type
  ,created
  ,last_ddl_time 
from dba_objects, 
( select 1 from dual connect by level <= 10);
pause
create index t_ix on t ( object_name );
pause
clear screen
set feedback on sql_id
select /*+ gather_plan_statistics */ 
  max(owner) owner, 
  max(object_name) object_name, 
  max(object_id) object_id, 
  max(object_type) object_type
from t
where object_id > 999990 
and object_name = 'YYYY';
set feedback on 
pause
select *
from dbms_xplan.display_cursor(sql_id=>'6ktd5gz4mwf2w',format=>'ALLSTATS');
pause
clear screen
select *
from dbms_xplan.display_cursor(sql_id=>'6ktd5gz4mwf2w',format=>'+OUTLINE')

pause
/
pause
clear screen
declare
  l_sql_tune_task_id  varchar2(100);
begin
  l_sql_tune_task_id := 
     dbms_sqltune.create_tuning_task (
        sql_id      => '6ktd5gz4mwf2w',
        scope       => dbms_sqltune.scope_comprehensive,
        time_limit  => 60,
        task_name   => 'my_tuning_task',
        description => 'tuning task');
end;
/
pause
exec dbms_sqltune.execute_tuning_task(task_name => 'my_tuning_task');
pause
set long 10000;
set pagesize 1000
set linesize 200
clear screen
select dbms_sqltune.report_tuning_task('my_tuning_task') rep
from dual

pause
/
pause
clear screen
select cast(attr5 as varchar2(1000)) hint
from dba_advisor_recommendations t,
     dba_advisor_rationale r 
where r.task_id = t.task_id
and   r.rec_id = t.rec_id
and   t.owner= user 
and   t.task_name = 'my_tuning_task'
and   t.type='SQL PROFILE';
pause
exec dbms_sqltune.drop_tuning_task (task_name => 'my_tuning_task');
clear screen
drop table t purge;
create table t as select * from dba_objects;
pause
set autotrace traceonly explain
select *
from t 
where owner = 'SYS';
pause
set autotrace off
clear screen
select count(*)
from t
where owner = 'SYS';
pause
set autotrace traceonly explain
select /*+ opt_estimate(@"SEL$1", TABLE, "T"@"SEL$1", SCALE_ROWS=24) */ *
from t 
where owner = 'SYS'

pause
/

