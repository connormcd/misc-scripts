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
@clean
set termout off
conn USER/PASSWORD@MY_PDB
col owner format a20
col table_name format a20
col column_name format a15
@drop emp
@drop dept
@drop v_join
set termout on
clear screen
set echo on
create table emp as 
select * from scott.emp;
pause
create table dept as 
select * from scott.dept;
pause
alter table dept add constraint dept_pk 
primary key(deptno);
pause
alter table emp add constraint emp_fk
foreign key(deptno) references dept;
pause
clear screen
create or replace view v_join as
select e.empno,e.ename, e.deptno, e.sal, d.dname,d.loc
from emp e, dept d
where e.deptno = d.deptno;
pause
select * from user_updatable_columns
where table_name = 'V_JOIN';
pause
clear screen
update v_join set sal = 6000 
where empno = 7499;
pause
select *
from  v_join
where empno = 7499;
pause
select *
from  emp
where empno = 7499;
pause
clear screen
update v_join 
set dname ='X' 
where empno = 7499

pause
/
pause
select * from dept;
pause
rollback;
pause
clear screen
select * from emp
where empno in (7499,7839);
pause
update v_join 
set dname ='Y' 
where empno in (7499,7839);
pause
select * from dept;
pause
roll;
pause
clear screen
select * from emp
where empno in (7499,7698);
pause
update v_join 
set dname = ename
where empno in (7499,7698);
pause
update v_join 
set dname ='Y' 
where empno in (7499,7698);
