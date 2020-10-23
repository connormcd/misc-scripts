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
conn USER/PASSWORD@MY_DB
set termout off
host del /q C:\oracle\diag\rdbms\db19\db19\trace\db19_j0*.trc
alter system flush shared_pool;
set termout off


drop table t purge;
drop table t1 purge;
set termout on
@clean
set echo on
select banner from v$version where rownum = 1;
create table t 
as select 0 x from dual;
create table t1 ( runs varchar2(20));
pause
clear screen
create or replace
procedure this_fails is
  l_var  int;
  l_calc int;
begin
  insert into t1 values ('Run '||to_char(sysdate,'HH24:MI:SS'));
  select x into l_var from t;
  update t set x = x + 1; 
  commit;
  l_calc := 1 / trunc(l_var/2);   -- raises zero_divide on first few executions
                                  -- OK on subsequent
end;
/
pause
clear screen

alter system set job_queue_processes = 0;
variable j number
begin
  dbms_job.submit(:j,'this_fails;');
  commit;
end;
/
print j
pause
clear screen
exec dbms_job.run(:j)
pause
select job, what, failures
from user_jobs;
pause

exec dbms_job.run(:j)
pause
select job, what, failures
from user_jobs;
pause

exec dbms_job.run(:j)
pause
select job, what, failures
from user_jobs;
pause

exec dbms_job.run(:j)
pause
select job, what, failures
from user_jobs;
pause

clear screen
select * from t;
pause
select * from t1;
pause
clear screen
alter system set job_queue_processes = 10;
pause
select job, what, failures
from user_jobs;
pause
select job, what, failures
from user_jobs;
pause
select job, what, failures
from user_jobs;
pause
clear screen
select * from t;
select * from t1;

