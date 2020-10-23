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
@drop emp
@drop job_parameters
@drop job_debug
col job_name format a30
col job_action format a30

create table emp as select * from scott.emp;
@clean
set termout on
set echo on
select banner from v$version where rownum = 1;
pause

create table job_parameters
 ( jobno    int,
   empno    int,
   new_sal  int
 );
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
select job, what
from user_jobs;
pause
select job, what
from user_jobs;
pause
select job, what
from user_jobs;
pause

clear screen
select empno, ename, sal
from   emp
where  empno = 7934;
pause

host dir /b C:\oracle\diag\rdbms\db19\db19\trace\db19_j0*.trc
pause

host cat C:\oracle\diag\rdbms\db19\db19\trace\db19_j0*.trc
pause

col text format a60
clear screen
select line, text
from   user_source
where  name = 'EMP_ADJUST'
order by line;
pause

clear screen
create table job_debug(msg varchar2(100));
pause

create or replace
procedure EMP_ADJUST(p_job int) is
  l_empno int;
  l_newsal int;
begin
  insert into job_debug values (p_job); commit;
  
--  select empno, new_sal
--  into   l_empno, l_newsal
--  from   job_parameters
--  where  jobno = p_job;
  
--  update emp
--  set    sal = l_newsal
--  where  empno = l_empno;
  dbms_lock.sleep(30);
end;
/
pause

set serverout on
clear screen
declare
  l_job int;
begin
  dbms_job.submit(l_job,'emp_adjust(job);');
  dbms_output.put_line('l_job='||l_job);
  commit;
end;
/
pause
select * from job_debug;
pause
select * from job_debug;
pause

select object_id, object_name, object_type
from   user_objects
where  object_type = 'JOB';
pause
set echo off
clear screen
pro |
pro |
pro | In 19c, DBMS_JOB ===> DBMS_SCHEDULER  !!!
pro |
pro |
pause
clear screen
set echo on
create or replace
procedure EMP_ADJUST(p_job int) is
  l_empno int;
  l_newsal int;
  l_real_job int;
begin
  select to_number(replace(object_name,'DBMS_JOB$_'))
  into   l_real_job
  from   user_objects
  where  object_id  = p_job;

  select empno, new_sal
  into   l_empno, l_newsal
  from   job_parameters
  where  jobno = l_real_job;   --- <<<====
  
  update emp
  set    sal = l_newsal
  where  empno = l_empno;
  dbms_lock.sleep(10);
end;
/
pause  
clear screen

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
select empno, ename, sal
from   emp
where  empno = 7934;
pause
select empno, ename, sal
from   emp
where  empno = 7934;
pause

set echo off
pro
pro Other implications .... back to 12.2, oh_job19b.sql
pro
