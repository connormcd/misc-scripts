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
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
drop table t_emp;
drop table t_dept;
drop view v_simple;
drop view v_join;
set termout on
set echo on
clear screen
create table t_emp as select * from scott.emp;
create index t_emp_ix on t_emp ( empno);
pause
clear screen
create or replace
view v_simple as select * from t_emp;
pause
select status
from   user_objects
where  object_name = 'V_SIMPLE';
pause
clear screen
drop index t_emp_ix;
pause
select status
from   user_objects
where  object_name = 'V_SIMPLE';
pause
clear screen

create UNIQUE index t_emp_ix on t_emp ( empno);
pause
create or replace
view v_simple as select * from t_emp;
pause
select status
from   user_objects
where  object_name = 'V_SIMPLE';
pause
clear screen
drop index t_emp_ix;
pause
select status
from   user_objects
where  object_name = 'V_SIMPLE';
pause
alter view v_simple compile;
pause
select status
from   user_objects
where  object_name = 'V_SIMPLE';
pause
clear screen

create table t_dept as select * from scott.dept;
create unique index t_dept_ix on t_dept ( deptno );  
pause
clear screen
create or replace
view v_join as
select e.*, d.dname
from   t_emp e, t_dept d
where  e.deptno = d.deptno;
pause
select status
from   user_objects
where  object_name = 'V_JOIN';
pause
clear screen
select column_name,updatable,insertable,deletable 
from   user_updatable_columns
where  table_name = 'V_JOIN';
pause
update v_join set sal = sal + 1;
pause
roll;
pause
clear screen
drop index t_dept_ix;
pause
select status
from   user_objects
where  object_name = 'V_JOIN';
pause
clear screen
select column_name,updatable,insertable,deletable 
from   user_updatable_columns
where  table_name = 'V_JOIN';
pause
update v_join set sal = sal + 1;
pause
select column_name,updatable,insertable,deletable 
from   user_updatable_columns
where  table_name = 'V_JOIN';
pause
select status
from   user_objects
where  object_name = 'V_JOIN';
