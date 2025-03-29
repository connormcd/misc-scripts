clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
alter session set read_only = false;
drop domain amex ;
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
col role format a50
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
prompt |  _____  ______          _____      ____  _   _ _  __     __
prompt | |  __ \|  ____|   /\   |  __ \    / __ \| \ | | | \ \   / /
prompt | | |__) | |__     /  \  | |  | |  | |  | |  \| | |  \ \_/ / 
prompt | |  _  /|  __|   / /\ \ | |  | |  | |  | | . ` | |   \   /  
prompt | | | \ \| |____ / ____ \| |__| |  | |__| | |\  | |____| |   
prompt | |_|  \_\______/_/    \_\_____/    \____/|_| \_|______|_|   
prompt |                                                           
pause
set echo on
clear screen
set echo on
set termout on
select * from scott.emp;
pause
clear screen
delete from scott.emp;
pause
roll;
pause
clear screen
alter session set read_only = true;
pause
delete from scott.emp;
pause
select * 
from scott.emp
for update;
pause
lock table scott.emp in exclusive mode;
pause
select * from session_roles;


pause Done

