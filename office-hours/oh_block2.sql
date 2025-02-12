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
@drop t
drop table scott.t purge;
alter system set max_idle_blocker_time = 0;
alter system set resource_manager_plan ='';
exec dbms_resource_manager.clear_pending_area();
exec dbms_resource_manager.create_pending_area();
exec dbms_resource_manager.delete_plan ('STOP_BLOCKERS');
exec dbms_resource_manager.delete_consumer_group ('CG_STOP_BLOCKERS');
exec dbms_resource_manager.validate_pending_area;
exec dbms_resource_manager.submit_pending_area();
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
begin
  dbms_resource_manager.create_pending_area();

  dbms_resource_manager.create_consumer_group(
    consumer_group=>'CG_STOP_BLOCKERS',
    comment=>'CG for stop blocking'
    );

  dbms_resource_manager.create_plan(
    plan=> 'STOP_BLOCKERS',
    comment=>'Plan for stop blocking'
  );

  dbms_resource_manager.create_plan_directive(
    plan=> 'STOP_BLOCKERS',
    group_or_subplan=>'CG_STOP_BLOCKERS',
    comment=>'Directive',
    max_idle_blocker_time => 10
  );

  dbms_resource_manager.create_plan_directive(
    plan=> 'STOP_BLOCKERS',
    group_or_subplan=>'OTHER_GROUPS',
    comment=>'leave others alone'
  );

  dbms_resource_manager.validate_pending_area;

  dbms_resource_manager.submit_pending_area();
end;
/
pause
clear screen
begin
  dbms_resource_manager_privs.grant_switch_consumer_group(
    'SCOTT','CG_STOP_BLOCKERS',false);
end;
/

begin
  dbms_resource_manager.set_initial_consumer_group( 
    user => 'SCOTT' , 
    consumer_group => 'CG_STOP_BLOCKERS');
end;
/
pause
alter system set resource_manager_plan ='STOP_BLOCKERS';
pause
clear screen
conn scott/tiger@DB_SERVICE
pause
create table t as select * from emp;
pause
delete from t;
--
-- Over to session 2, oh_block2a.sql
--
pause
select * from t;
