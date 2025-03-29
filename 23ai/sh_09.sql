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
prompt |  _____ ____      _    _   _ ____  ____ ___ _     _____ ____  
prompt | |_   _|  _ \    / \  | \ | / ___||  _ \_ _| |   | ____|  _ \ 
prompt |   | | | |_) |  / _ \ |  \| \___ \| |_) | || |   |  _| | |_) |
prompt |   | | |  _ <  / ___ \| |\  |___) |  __/| || |___| |___|  _ < 
prompt |   |_| |_| \_\/_/   \_\_| \_|____/|_|  |___|_____|_____|_| \_\
prompt |                                                              
prompt |
pause
set echo on
clear screen

set echo on
set termout on
create table person
 ( pid int,
   first_name varchar2(20),
   last_name  varchar2(20)
 );
pause
insert into person values (1,'Mike','Hichwa');
pause
insert into person values (2,'Maria','Colgan');
pause
insert into person values (3,'LARRY','ELLISON');
pause
clear screen
select 
  initcap(first_name) first_name,
  initcap(last_name) last_name
from person
where initcap(first_name) is not null;
pause
clear screen
insert into person values (4,'Connor','McDonald');
pause
select 
  initcap(first_name) first_name,
  initcap(last_name) last_name
from person
where initcap(first_name) is not null;
pause
clear screen
create or replace
function my_initcap(p_string varchar2) return varchar2 is
begin
  return
      case
        when regexp_like(p_string,'(Mac[A-Z]|Mc[A-Z])') then p_string
        when p_string like '''%' then p_string
        when initcap(p_string) like '_''S%' then p_string
        else replace(initcap(p_string),'''S','''s')
      end;
end;
/
pause
select 
  my_initcap(first_name) first_name,
  my_initcap(last_name) last_name
from person
where my_initcap(first_name) is not null;
pause
set echo off
clear screen
pro |  
pro |   __     ______  _    _       _____ _____ _____       __          ___    _       _______   ___ ___  
pro |   \ \   / / __ \| |  | |     |  __ \_   _|  __ \      \ \        / / |  | |   /\|__   __| |__ \__ \ 
pro |    \ \_/ / |  | | |  | |     | |  | || | | |  | |      \ \  /\  / /| |__| |  /  \  | |       ) | ) |
pro |     \   /| |  | | |  | |     | |  | || | | |  | |       \ \/  \/ / |  __  | / /\ \ | |      / / / / 
pro |      | | | |__| | |__| |     | |__| || |_| |__| |        \  /\  /  | |  | |/ ____ \| |     |_| |_|  
pro |      |_|  \____/ \____/      |_____/_____|_____/          \/  \/   |_|  |_/_/    \_\_|     (_) (_)  
pro |                                                                                                     
pro |                                                                                                     
pause
set echo on
clear screen
alter system flush shared_pool;
pause
alter session set sql_transpiler = 'ON';
pause
explain plan for
select 
  my_initcap(first_name) first_name,
  my_initcap(last_name) last_name
from person
where my_initcap(first_name) is not null;
pause
select * 
from dbms_xplan.display();

pause Done
