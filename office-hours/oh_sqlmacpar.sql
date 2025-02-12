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
col emp_posn format a30
set termout on
set lines 120
@drop t
drop function emp_plus_dname;
drop view emp_plus_dname;
clear screen
set feedback on
set serverout on
set echo on
create or replace
function emp_plus_dname
return varchar2 sql_macro is
begin
  return q'{
     select e.empno, e.ename, d.dname
     from emp e, dept d
     where e.deptno = d.deptno
     }';
end;
/
pause
select * from emp_plus_dname();
pause
clear screen
drop function emp_plus_dname;
pause
create or replace
view emp_plus_dname as
select e.empno, e.ename, d.dname
from emp e, dept d
where e.deptno = d.deptno;
pause
select * from emp_plus_dname;
pause
clear screen
create or replace 
function emp_dept(p_deptno number)
return varchar2 sql_macro is
begin
  return q'{
     select *
     from emp 
     where deptno = p_deptno
     }';
end;
/
pause
select * from emp_dept(10);
pause
clear screen
create or replace 
function jump_into_hier(p_entry number)
return varchar2 sql_macro is
begin
  return q'{
     select lpad(' ',level*2)||empno emp_posn, ename 
     from emp 
     start with empno = p_entry
     connect by prior empno = mgr
     }';
end;
/
pause
select * from jump_into_hier(7839);
pause
select * from jump_into_hier(7698);
pause
clear screen
create or replace 
function query_any_table(p_tab dbms_tf.table_t)
return varchar2 sql_macro is
begin
  return q'{select * from p_tab}';
end;
/
pause
select * from query_any_table(emp);
pause
select * from query_any_table(dept);
pause
clear screen
create table t
partition by list ( owner ) 
( partition sys values ('SYS'),
  partition system values ('SYSTEM' ),
  partition others values (default)
)
as select * from dba_objects;
pause
select count(*) from t partition ( sys );
pause
clear screen
create or replace 
function count_single_partition(parname varchar2)
return varchar2 sql_macro is
begin
  return q'{select count(*) from t partition (parname)}';
end;
/
pause
select * 
from count_single_partition('SYS');
pause
clear screen
create or replace 
function count_single_partition(parname varchar2)
return varchar2 sql_macro is
begin
  dbms_output.put_line('parname='||parname);
  return q'{select count(*) from t partition (parname)}';
end;
/
pause
set serverout on
select * 
from count_single_partition('SYS');
pause
select * 
from count_single_partition(sys);
pause
clear screen
create or replace 
function count_single_partition(p_tab dbms_tf.table_t)
return varchar2 sql_macro is
begin
  return q'{select count(*) from p_tab}';
end;
/
pause
select *
from count_single_partition(t partition(sys));
pause
with one_par as 
( 
  select * 
  from t partition (sys )
)
select *
from count_single_partition(one_par);
pause
clear screen
create or replace 
function count_single_partition(parname dbms_tf.columns_t)
return varchar2 sql_macro is
begin
  return q'{select count(*) from t partition (}'||parname(1)||')';
end;
/
pause
select *
from count_single_partition(columns(sys));

