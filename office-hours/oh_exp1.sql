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
@drop emp
@drop dept
clear screen
set echo on
set termout on

create table emp as 
select * from scott.emp;
create table dept as 
select * from scott.dept;
pause
alter table emp add constraint emp_pk primary key ( empno );
alter table dept add constraint dept_pk primary key ( deptno );
pause
clear screen
select e.job, count(d.dname)
from   dept d,
       emp  e
where  d.deptno = e.deptno
group by e.job

pause
clear screen
set autotrace traceonly explain
/
set autotrace off

pause
clear screen
alter table dept modify dname not null;
alter table emp add constraint emp_fk 
foreign key (deptno) references dept ( deptno );
pause
clear screen
set autotrace traceonly explain
select e.job, count(d.dname)
from   dept d,
       emp  e
where  d.deptno = e.deptno
group by e.job;
set autotrace off

