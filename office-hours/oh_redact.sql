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
begin
   dbms_redact.drop_policy (
      object_schema => 'MY_USER',
      object_name => 'EMP',
      policy_name => 'Commission'
  );
end;
/
begin
   dbms_redact.drop_policy (
      object_schema => 'MY_USER',
      object_name => 'EMP_SALESMAN',
      policy_name => 'Commission'
  );
end;
/

drop user enduser cascade;
create user enduser identified by enduser;
grant create session to enduser;
@drop emp
create table emp as select * from scott.emp;
grant select on emp to enduser;
update emp
set comm = 5000+ trunc(dbms_random.value(1000,2000))
where job = 'SALESMAN';

update emp
set comm = 100
where job = 'ANALYST';

set termout on
@clean
set echo on

select * from my_user.emp
order by job, empno;
pause
clear screen
conn enduser/enduser@MY_DB
select * from my_user.emp
order by job, empno;
pause

set termout off
conn USER/PASSWORD@MY_DB
set echo on
clear screen
set termout on
show user
pause

begin
   dbms_redact.add_policy (
      object_schema => 'MY_USER',
      object_name => 'EMP',
      policy_name => 'Commission',
      expression => '1=1',
      column_name => 'COMM',
      function_type => dbms_redact.full
  );
end;
/
pause

select * from my_user.emp
order by job, empno;
pause
clear screen

conn enduser/enduser@MY_DB
pause
select * from my_user.emp
order by job, empno;
pause

set termout off
conn USER/PASSWORD@MY_DB
set echo on
clear screen
set termout on
show user
pause
begin
   dbms_redact.drop_policy (
      object_schema => 'MY_USER',
      object_name => 'EMP',
      policy_name => 'Commission'
  );
end;
/
pause

clear screen
begin
   dbms_redact.add_policy (
      object_schema => 'MY_USER',
      object_name => 'EMP',
      policy_name => 'Commission',
      expression => 'job = ''SALESMAN''',
      column_name => 'COMM',
      function_type => dbms_redact.full
  );
end;
.
pause
/
pause
clear screen

revoke select on EMP from enduser;
pause

create or replace 
view EMP_SALESMAN as
select * from emp
where job = 'SALESMAN';
pause

create or replace 
view EMP_OTHER as
select * from emp
where job != 'SALESMAN';
pause

create or replace 
view EMP_ALL as
select * from emp_salesman
union all
select * from emp_other;
pause

clear screen
select * from my_user.emp_all
order by job, empno;
pause

grant select on EMP_ALL to enduser;
pause

create synonym enduser.emp for emp_all;
pause
clear screen
conn enduser/enduser@MY_DB
pause

select * from emp
order by job, empno;
pause

set termout off
conn USER/PASSWORD@MY_DB
set echo on
clear screen
set termout on
show user


begin
   dbms_redact.add_policy (
      object_schema => 'MY_USER',
      object_name => 'EMP_SALESMAN',
      policy_name => 'Commission',
      expression => '1=1',
      column_name => 'COMM',
      function_type => dbms_redact.full
  );
end;
/
pause
clear screen

conn enduser/enduser@MY_DB
set echo off
@oh_redact2.sql
set echo off
pause
pro  +------------------------------------+
pro  |                                    |
pro  |  Sadly........its all fake :-(     |
pro  |                                    |
pro  +------------------------------------+
set echo on
pause
host cat c:\oracle\sql\oh_redact2.sql
pause
clear screen
select * from emp
order by job, empno;

pause
set termout off
conn USER/PASSWORD@MY_DB
set echo on
clear screen
set termout on
show user
pause


grant select on emp_salesman to enduser;
grant select on emp_other to enduser;
pause
conn enduser/enduser@MY_DB
pause
clear screen
select * from my_user.emp_salesman;
pause
select * from my_user.emp_other;
pause
clear screen
select * from my_user.emp_salesman
union all
select * from my_user.emp_other

pause
/
pause

set termout off
conn USER/PASSWORD@MY_DB
set echo on
clear screen
set termout on
show user
pause

drop view emp_salesman;
drop view emp_other;

create or replace
view EMP_ALL as
select EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,0 COMM, DEPTNO
from   emp
where  job = 'SALESMAN'
union all
select EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM, DEPTNO
from   emp
where  job != 'SALESMAN';
pause

grant select on EMP_ALL to enduser;
pause
clear screen
conn enduser/enduser@MY_DB
pause
select * from emp
order by job, empno;
