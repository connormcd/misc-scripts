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
@drop t
begin
dbms_rls.drop_policy ( 
   object_schema=>user,
   object_name=>'T',
   policy_name=>'T_POL'); 
end;
/
set pages 999
set termout on
clear screen
set echo on
create table t 
partition by list ( deptno )
( partition p10 values (10),
  partition p20 values (20)
) as 
select deptno, empno, ename, sal, comm, job
from scott.emp
where deptno in (10,20);
pause
alter table t modify partition p10 read only;
pause
delete from t where deptno = 20;
pause
delete from t where deptno = 10;
pause
clear screen
drop table t purge;
create table t as 
select * from scott.emp;
pause
select * from emp;
pause
clear screen
alter table t add constraint chk
check 
 (
  ( deptno = 10 and 1 = 0 ) or
  ( deptno != 10 )
)

pause
/
pause
alter table t add constraint chk
check 
 (
  ( deptno = 10 and 1 = 0 ) or
  ( deptno != 10 )
) enable novalidate;
pause
clear screen
update t
set sal = sal + 1
where deptno = 20;
pause
update t
set sal = sal + 1
where deptno = 10;
pause
update t
set sal = sal + 1, deptno = deptno
where deptno = 10;
pause
clear screen
alter table t drop constraint chk;
pause
alter table t add constraint chk
check 
 (
  ( deptno = 10 and 
    empno = -1 and
    ename = '~' and 
    job = '~' and 
    mgr = -1 and
    hiredate = date '0001-01-01' and
    sal = -1 and 
    comm = -1 ) or
  ( deptno != 10 )
) enable novalidate;
pause
clear screen
update t
set sal = sal + 1
where deptno = 10;
pause
update t
set comm = null
where deptno = 10;
pause
clear screen
delete from t
where deptno = 10
and rownum = 1;
pause
roll;
pause
alter table t drop constraint chk;
pause
clear screen
create or replace
trigger t_read_only
before insert or update or delete
on t
for each row
begin
  if :new.deptno = 10 or :old.deptno = 10 then
     raise_application_error(-20000,'Dept 10 is read only');
  end if;
end;
/
pause
update t
set sal = sal + 1
where deptno = 20;
pause
update t
set sal = sal + 1
where deptno = 10;
pause
delete from t
where deptno = 10
and rownum = 1;
pause
roll;
set echo off
pro |
pro | Anyone guess a flaw?
pro |
pause
drop trigger t_read_only;
clear screen
set echo on
grant all on t to scott;
pause
create or replace
package pol is 
  function t_pol_func(owner varchar2, objname varchar2) return varchar2;
end;
/
pause
create or replace
package body pol is 
function t_pol_func(owner varchar2, objname varchar2) return varchar2 is
begin
  return 'deptno != 10';
end;
end;
/
pause
clear screen
begin
dbms_rls.add_policy ( 
   object_schema=>user,
   object_name=>'T',
   policy_name=>'T_POL',
   function_schema=>user,
   policy_function=>'POL.T_POL_FUNC',
   statement_types=>'INSERT,UPDATE,DELETE',
   update_check=>true,
   enable=>true); 
end;
/
pause
clear screen
conn scott/tiger@DB_SERVICE
pause
insert into myuser.t ( empno, job, deptno)
values (100,'X',20);
pause
insert into myuser.t ( empno, job, deptno)
values (100,'X',10);
pause
clear screen
select * from myuser.t
where empno = 7369;
pause
update myuser.t   
set sal = sal + 1
where empno = 7369; 
pause
clear screen
select * from myuser.t
where empno = 7934;
pause
update myuser.t   
set sal = sal + 1
where empno = 7934; 
pause
delete myuser.t   
where empno = 7934; 
roll;
