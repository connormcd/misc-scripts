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
conn USER/PASSWORD@db122
alter system flush shared_pool;
set termout off
@drop emp
@drop job_parameters

create table emp as select * from scott.emp;
@clean
set termout on
set echo on
select banner from v$version where rownum = 1;
pause
select * from emp;
pause
clear screen
create or replace
procedure EMP_ADJUST(p_empno int, p_sal int) is
begin
  update emp
  set    sal = p_sal
  where  empno = p_empno;
end;
/
pause

clear screen
select empno, ename, sal
from   emp
where  empno = 7934;
pause
exec emp_adjust(7934,1000);
pause
select empno, ename, sal
from   emp
where  empno = 7934;
pause
roll;
pause
clear screen

create or replace
procedure EMP_ADJUST(p_empno int, p_sal int) is
begin
  update emp
  set    sal = p_sal
  where  empno = p_empno;
  dbms_lock.sleep(10);
end;
/
pause
exec emp_adjust(7934,1000);
pause
roll;
pause
clear screen
alter system set job_queue_processes = 0;
pause
variable j number
exec  dbms_job.submit(:j,'emp_adjust(7934,1000);');
print j
commit;
pause
select job, what
from user_jobs;
pause
clear screen
alter system set job_queue_processes = 10;
pause
select empno, ename, sal
from   emp
where  empno = 7934;
pause
select empno, ename, sal
from   emp
where  empno = 7934;
pause
select empno, ename, sal
from   emp
where  empno = 7934;
pause
clear screen

variable j number
exec  dbms_job.submit(:j,'emp_adjust(7934,1000);');
pause

select job, what
from user_jobs;
pause

roll;
pause
clear screen

create table job_parameters
 ( jobno    int,
   empno    int,
   new_sal  int
 );
pause
set echo off
clear screen
pro |
pro | Chicken and Egg !
pro |
pro | exec dbms_job(the_returned_job, 'emp_adjust(?????)');
pro |                ^^^^^^^^^^^^^ ================>>>>                
pro |
pro
set echo on
pause
clear screen

create or replace
procedure EMP_ADJUST(p_job int) is
  l_empno int;
  l_newsal int;
begin
  select empno, new_sal
  into   l_empno, l_newsal
  from   job_parameters
  where  jobno = p_job;
  
  update emp
  set    sal = l_newsal
  where  empno = l_empno;
  dbms_lock.sleep(10);
end;
/
pause
clear screen
alter system set job_queue_processes = 0;
pause 
declare
  l_job int;
begin
  dbms_job.submit(l_job,'emp_adjust(job);');
  insert into job_parameters
  values (l_job,7934,2000);
  commit;
end;
/
pause 
clear screen
select job, what
from user_jobs;
pause 

select * from job_parameters;
pause 
clear screen

alter system set job_queue_processes = 10;
pause

select sid,job from dba_jobs_running;
pause
select sid,job from dba_jobs_running;
pause
select sid,job from dba_jobs_running;
pause

select sql_text
from   v$sql
where  sql_text like 'DECLARE%:job%emp_adjust(job%';

pause
set echo off
pro
pro And now onto 19c... oh_job19a.sql
pro
