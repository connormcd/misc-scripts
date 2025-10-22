clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop myemp
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |   
prompt |     ______ _______       _____ 
prompt |    |  ____|__   __|/\   / ____|
prompt |    | |__     | |  /  \ | |  __ 
prompt |    |  __|    | | / /\ \| | |_ |
prompt |    | |____   | |/ ____ \ |__| |
prompt |    |______|  |_/_/    \_\_____|
prompt |                                
prompt |
pause
set echo on
clear screen
create table myemp (
  empno                   number(4),
  ename                   varchar2(10),
  job                     varchar2(9),
  mgr                     number(4),
  hiredate                date,
  sal                     number(7,2),
  comm                    number(7,2),
  deptno                  number(2)
);
pause
insert into myemp 
select * from scott.emp;
commit;
pause
clear screen
select *
from myemp
where empno = 7369;
pause
clear screen
--
-- time to update
--
pause
select empno
from  myemp
where empno  = 7369
and ename    = 'SMITH'
and job      = 'CLERK'
and mgr      = 7902
and hiredate = '17-DEC-80'
and sal      = 800
and deptno   = 20
for update nowait;
pause
--
-- if no rows, then "someone else changed"
--
pause
update myemp
set sal = 1000
where empno  = 7369;
pause
roll;
clear screen
--
-- or update with predicates
--
update myemp
set sal = 1000
where empno  = 7369
and ename    = 'SMITH'
and job      = 'CLERK'
and mgr      = 7902
and hiredate = '17-DEC-80'
and sal      = 800
and deptno   = 20;
--
-- if no rows, then "someone else changed"
--
pause
roll;
clear screen
alter table myemp add row_version int default on null 1;
pause
update myemp set row_version = 1;
pause
create or replace
trigger myemp_concurrency 
before insert or update 
on myemp
for each row
begin
  :new.row_version := :new.row_version + 1;
end;
/
pause
clear screen
select empno, sal, row_version 
from myemp
where empno = 7369;
pause
update myemp
set sal = 1000
where empno  = 7369
  --and ename    = 'SMITH'
  --and job      = 'CLERK'
  --and mgr      = 7902
  --and hiredate = '17-DEC-80'
  --and sal      = 800
  --and deptno   = 20
and row_version = 1;
--
-- if no rows, then "someone else changed"
--
pause
roll;
clear screen
alter table myemp drop column row_version;
pause
drop trigger myemp_concurrency;
pause
clear screen
select empno, sal, sys_row_etag(empno,sal)
from myemp
where empno = 7369;
pause
update myemp
set sal = 1000
where empno  = 7369
and sys_row_etag(empno,sal) = '27E7249E5C6D5B3936354B2CCCF1C895';
pause
select empno, sal, sys_row_etag(empno,ename,job,mgr,hiredate,deptno,sal,comm)
from myemp
where empno = 7369;
pause
select empno, sal, sys_row_etag(*)
from myemp
where empno = 7369;

pause Done
