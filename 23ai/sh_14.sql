clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
@drop credit_card
drop domain amex ;
drop domain bigcase;
@drop emp_contractors
drop domain emp_contract;
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set termout on
set echo off
clear screen
set termout on
set echo off
prompt |
prompt |  _   _ ____  ____    _  _____ _____        _  ___ ___ _   _ 
prompt | | | | |  _ \|  _ \  / \|_   _| ____|      | |/ _ \_ _| \ | |
prompt | | | | | |_) | | | |/ _ \ | | |  _|     _  | | | | | ||  \| |
prompt | | |_| |  __/| |_| / ___ \| | | |___   | |_| | |_| | || |\  |
prompt |  \___/|_|   |____/_/   \_\_| |_____|   \___/ \___/___|_| \_|
prompt |                                                            
pause
set echo on
clear screen

select * from emp;
pause

update emp
set sal = sal + 1
where deptno = -- sales or dallas???

pause
clear screen
select * from dept;
pause
update emp
set sal = sal + 0.5
where deptno in (
  select d.deptno
  from   dept d
  where  d.dname = 'SALES'
    or   d.loc = 'DALLAS'
  );
pause
select * from emp;
pause
roll;
pause
clear screen
update emp e
set sal = sal + 0.5
#pause
from dept d
where d.deptno = e.deptno
and ( d.dname = 'SALES'
    or   d.loc = 'DALLAS' );
pause
select * from emp;
roll;
pause
clear screen
update emp e
set sal = sal + d.deptno
#pause
from dept d
where d.deptno = e.deptno
and ( d.dname = 'SALES'
    or   d.loc = 'DALLAS' );
pause
roll;

pause Done
