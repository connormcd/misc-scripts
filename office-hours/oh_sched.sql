REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
clear screen
begin
  dbms_scheduler.set_scheduler_attribute(
    attribute => 'default_timezone',
    value     => 'US/MOUNTAIN');
end;
/

exec dbms_scheduler.drop_job('DOES_NOTHING',force=>true);
col start_date format a48
col next_run_date format a48
@clean
set lines 100
set echo on
select systimestamp from dual;
pause
begin
    dbms_scheduler.create_job (
       job_name           =>  'DOES_NOTHING',
       job_type           =>  'PLSQL_BLOCK',
       job_action         =>  'begin null; end;',
       start_date         =>  systimestamp,
       repeat_interval    =>  'FREQ=DAILY',
       enabled            =>  true);
end;
/
pause
select start_date, next_run_date
from   user_scheduler_jobs
where  job_name = 'DOES_NOTHING';
pause
clear screen
exec dbms_scheduler.drop_job('DOES_NOTHING',force=>true);
pause
begin
    dbms_scheduler.create_job (
       job_name           =>  'DOES_NOTHING',
       job_type           =>  'PLSQL_BLOCK',
       job_action         =>  'begin null; end;',
       repeat_interval    =>  'FREQ=DAILY',
       enabled            =>  true);
end;
/
pause
select start_date, next_run_date
from   user_scheduler_jobs
where  job_name = 'DOES_NOTHING';
pause
clear screen
select systimestamp from dual;
pause
select dbms_scheduler.stime from dual;
pause
clear screen
begin
  dbms_scheduler.set_scheduler_attribute(
    attribute => 'default_timezone',
    value     => 'AUSTRALIA/PERTH');
end;
/
pause
clear screen

clear screen
exec dbms_scheduler.drop_job('DOES_NOTHING',force=>true);
pause
begin
    dbms_scheduler.create_job (
       job_name           =>  'DOES_NOTHING',
       job_type           =>  'PLSQL_BLOCK',
       job_action         =>  'begin null; end;',
       repeat_interval    =>  'FREQ=DAILY',
       enabled            =>  true);
end;
/
pause
select start_date, next_run_date
from   user_scheduler_jobs
where  job_name = 'DOES_NOTHING';
