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
conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
exec dbms_scheduler.drop_job('DEMOJOB',force=>true);
exec dbms_scheduler.drop_program('DEMOPROG',force=>true);
exec dbms_scheduler.drop_schedule('DEMOSCHED',force=>true);
exec dbms_scheduler.drop_job_class('DEMOCLASS');
@drop t
drop user demouser cascade;
set long 50000
set termout on
set echo on
create table t ( x int );
pause
select dbms_metadata.get_ddl('TABLE','T',user) ddl from dual;
pause
clear screen
create user demouser identified by mypassword;
pause
select dbms_metadata.get_ddl('USER','DEMOUSER') ddl from dual;
pause
clear screen
begin
  dbms_scheduler.create_job (
    job_name        => 'DEMOJOB',
    job_type        => 'plsql_block',
    job_action      => 'begin null; end;',
    start_date      => systimestamp,
    repeat_interval => 'freq=daily; byhour=9',
    enabled         => false);
end;
/
pause
select dbms_metadata.get_ddl('JOB','DEMOJOB',user) ddl from dual;
pause
clear screen
select dbms_metadata.get_ddl('PROCOBJ','DEMOJOB',user) ddl from dual

pause
/
pause
clear screen
begin
  dbms_scheduler.create_program (
    program_name   => 'DEMOPROG',
    program_type   => 'plsql_block',
    program_action => 'begin null; end;',
    enabled        => false);
end;
/

begin
  dbms_scheduler.create_schedule (
    schedule_name   => 'DEMOSCHED',
    start_date      => systimestamp,
    repeat_interval => 'freq=daily',
    end_date        => null);
end;
/
pause
clear screen
select dbms_metadata.get_ddl('PROCOBJ','DEMOPROG',user) ddl from dual;
pause

select dbms_metadata.get_ddl('PROCOBJ','DEMOSCHED',user) ddl from dual;
pause
clear screen
begin
  dbms_scheduler.create_job_class (
    job_class_name=> 'DEMOCLASS');
end;
/
pause
select dbms_metadata.get_ddl('PROCOBJ','DEMOCLASS',user) ddl from dual;
pause
clear screen

variable j number
exec dbms_job.submit(:j,'null;',sysdate+1000);
commit;
pause
select job, what from user_jobs
where what like '%null%';
pause
select job_name
from   user_scheduler_jobs
where  job_name like 'DBMS_JOB%';
pause
select dbms_metadata.get_ddl('PROCOBJ','DBMS_JOB$_'||:j,user) ddl from dual;
pause
exec dbms_job.remove(:j);
commit;
