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
prompt |  __  __ _   _ _   _____ ___    ____ ___ ____  _____ ____ _____ 
prompt | |  \/  | | | | | |_   _|_ _|  |  _ \_ _|  _ \| ____/ ___|_   _|
prompt | | |\/| | | | | |   | |  | |   | | | | || |_) |  _|| |     | |  
prompt | | |  | | |_| | |___| |  | |   | |_| | ||  _ <| |__| |___  | |  
prompt | |_|  |_|\___/|_____|_| |___|  |____/___|_| \_\_____\____| |_|  
prompt |                                                               
prompt |
pause
set echo on
clear screen
set echo on
set termout on
clear screen
conn scott/tiger@db19
set termout off
drop table emp2 purge;
set termout on
create table emp2 as 
select 
  empno,
  ename,
  sal,
  comm
from scott.emp
where 1=0;
pause
insert /*+ APPEND */ into emp2
select  
  empno,
  ename,
  sal,
  comm
from scott.emp;
pause
select * from emp2;
pause
commit;

clear screen
conn scott/tiger@db23
set echo on
drop table if exists emp2 purge;
set termout on
create table emp2 as 
select 
  empno,
  ename,
  sal,
  comm
from scott.emp
where 1=0;
pause
insert /*+ APPEND */ into emp2
select  
  empno,
  ename,
  sal,
  comm
from scott.emp;
pause
select * from emp2;
pause
insert /*+ APPEND */ into emp2
select  
  empno,
  ename,
  sal,
  comm
from scott.emp;
pause
select * from emp2;
commit;

pause Done
