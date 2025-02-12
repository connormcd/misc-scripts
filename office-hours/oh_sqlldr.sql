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
drop user demo cascade;
set termout on
set echo on
grant dba, select any table to demo identified by demo;
pause
conn demo/demo@DB_SERVICE
pause
create global temporary table emp
on commit preserve rows
as select * from scott.emp;
pause
host cat x:\temp\emp.ctl
pause
clear screen
host sqlldr control=x:\temp\emp.ctl userid=demo/demo@DB_SERVICE
pause
set echo off
pro |
pro | BUT WHY !?!??!
pro |
set echo on
pause
create table tgt as 
select * from scott.emp where 1=0;
pause
clear screen
create or replace
trigger trg
before insert on emp
for each row
declare
  l_cnt int;
begin
  if :new.sal > 1000 then
    select count(*)
    into   l_cnt
    from   scott.dept
    where  deptno = :new.deptno;
    
    if l_cnt > 0 then
      insert into tgt (empno, ename, sal)
      values (:new.empno, :new.ename, :new.sal*10);
    end if;
  end if;
end;
/
pause
clear screen
rename emp to emp_tab;
pause
create or replace view emp 
as select * from emp_tab;
pause
drop trigger trg;
pause
create or replace
trigger trg
instead of insert on emp
for each row
declare
  l_cnt int;
begin
  if :new.sal > 1000 then
    select count(*)
    into   l_cnt
    from   scott.dept
    where  deptno = :new.deptno;
    
    if l_cnt > 0 then
      insert into tgt (empno, ename, sal)
      values (:new.empno, :new.ename, :new.sal*10);
    end if;
  end if;
end;
/
pause
clear screen
host sqlldr control=x:\temp\emp.ctl userid=demo/demo@DB_SERVICE
pause
select * from tgt;


