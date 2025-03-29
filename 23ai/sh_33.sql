clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
drop domain amex ;
@drop credit_card
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
prompt |
prompt |  _   _ ____  ____    _  _____ _____     ___  _   _    _   _ _   _ _     _     
prompt | | | | |  _ \|  _ \  / \|_   _| ____|   / _ \| \ | |  | \ | | | | | |   | |    
prompt | | | | | |_) | | | |/ _ \ | | |  _|    | | | |  \| |  |  \| | | | | |   | |    
prompt | | |_| |  __/| |_| / ___ \| | | |___   | |_| | |\  |  | |\  | |_| | |___| |___ 
prompt |  \___/|_|   |____/_/   \_\_| |_____|   \___/|_| \_|  |_| \_|\___/|_____|_____|
prompt |                                                                             
pause
set echo on
clear screen

set echo on
set termout on
set lines 80
clear screen
create table emp2 as 
select 
  empno,
  ename,
  sal,
  comm
from scott.emp
where 1=0;
pause
desc emp2
pause
clear screen
alter table emp2
   modify comm default 100;
pause
insert into emp2 (empno, ename)
values (100,'Connor');
pause
select * from emp2;
pause
insert into emp2 (empno, ename,comm)
values (101,'Mark',null);
pause
select * from emp2;
pause
clear screen
update emp2 set comm = 100
where ename = 'Mark';
pause
alter table emp2
   modify comm default on null 200;
pause
insert into emp2 (empno, ename,comm)
values (102,'Sue',null);
pause
select * from emp2;
pause
clear screen
update emp2
set comm = null
where empno = 101;
pause
select * from emp2;
pause
declare
  l_row emp2%rowtype;
begin
  l_row.empno := 101;
  l_row.ename := 'Marky';
  l_row.sal   := 500;
  
  update emp2
  set    row = l_row
  where  empno = 101;
end;
/
pause
alter table emp2
   modify comm default on null 
   for insert and update 150;
pause
update emp2
set comm = null
where empno = 101;
pause
select * from emp2;

pause Done
