clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
drop user jane_doe cascade;
drop domain amex ;
@drop t1
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
alter table products modify total_sold not reservable;
@drop products
@drop seq
@drop myemp
@drop customer
@drop dept_doc
@drop orders
@drop orderitems
col journal new_value journal_table
col journal format a30
set verify off
drop view orders_ov;
@dropc order_items
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
col first_name format a20
col last_name format a20
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |  ____   ___  _       _   _ ___ ____ _____ ___  ______   __
prompt | / ___| / _ \| |     | | | |_ _/ ___|_   _/ _ \|  _ \ \ / /
prompt | \___ \| | | | |     | |_| || |\___ \ | || | | | |_) \ V / 
prompt |  ___) | |_| | |___  |  _  || | ___) || || |_| |  _ < | |  
prompt | |____/ \__\_\_____| |_| |_|___|____/ |_| \___/|_| \_\|_|  
prompt |                                                           
pause
set echo on
clear screen
conn sys/SYS_PASSWORD@db23 as sysdba
alter system set sql_history_enabled = true scope=spfile;
pause
shutdown immediate
startup
pause
set termout off
clear screen
conn dbdemo/dbdemo@db23
set echo on
set termout on
show user
pause
select count(*) from emp;
select count(*) from dept;
select count(*) from my_non_existent_table;
pause
set lines 70
desc v$sql_history
set lines 120
pause
col sql_text format a60 trunc
col err format 9999
clear screen
select 
  sql_id, 
  to_char(last_active_time,'HH24:MI:SS') last_run,
  cpu_time,
  error_number err,
  replace(sql_text,chr(10),' ') sql_text
from v$sql_history;
pause
select distinct sid 
from v$sql_history;

pause Done
