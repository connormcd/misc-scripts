REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

conn /@MYDB as sysdba
begin
  dbms_resource_manager.create_pending_area();

  -- create a consumer group that users will sit in
  --
  dbms_resource_manager.create_consumer_group(
    consumer_group=>'CANCEL_ON_LONG_EXECUTION',
    comment=>'Consumer group that will keep an eye on statement execution'
    );

  -- and we need a resource plan
  --
  dbms_resource_manager.create_plan(
    PLAN=> 'EXECUTION_TIME_LIMIT',
    comment=>'Kill statements after exceeding total execution time'
  );

  -- create a plan directive for that consumer group
  -- the plan will cancel the current SQL if it runs for more than '10' sec
  --
  dbms_resource_manager.create_plan_directive(
    plan=> 'EXECUTION_TIME_LIMIT',
    group_or_subplan=>'CANCEL_ON_LONG_EXECUTION',
    comment=>'Kill statement after exceeding total execution time',
    switch_group=>'CANCEL_SQL',
    switch_time=>10,
    switch_estimate=>false,
    switch_for_call=>true
  );

  -- fallback bucket for non-impacted users
  --
  dbms_resource_manager.create_plan_directive(
    plan=> 'EXECUTION_TIME_LIMIT',
    group_or_subplan=>'OTHER_GROUPS',
    comment=>'leave others alone'
  );

  dbms_resource_manager.validate_pending_area;

  dbms_resource_manager.submit_pending_area();

end;
/

clear screen
-- allow SCOTT to be put into this group
--
begin
  dbms_resource_manager_privs.grant_switch_consumer_group(
     'SCOTT',
     'CANCEL_ON_LONG_EXECUTION',
     false);
end;
/

-- activate our plan
--
alter system set 
  resource_manager_plan ='EXECUTION_TIME_LIMIT';

clear screen
conn scott/tiger@MYDB

-- switch SCOTT into the time limit group
--
declare
  l_cg  varchar2(100);
begin
  dbms_session.switch_current_consumer_group('CANCEL_ON_LONG_EXECUTION',l_cg,true);
end;
/

set timing on
select count(*) from all_source;
select count(*) from all_source,all_source;
