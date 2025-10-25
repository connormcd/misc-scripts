clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system reset txn_auto_rollback_high_priority_wait_target;
alter system reset priority_txns_high_wait_target;
drop user jane_doe cascade;
drop domain amex ;
@drop t1
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
drop trigger SCOTT.BAD_TRIG;
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
@drop t1
@drop t2
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
drop user lazy_joe cascade;
drop user daily_pay_run cascade;

clear screen
set termout on
set echo off
prompt |
prompt |
prompt |  _______  ___   _   ____  ____  ___ ___  ____  ___ _______   __
prompt | |_   _\ \/ / \ | | |  _ \|  _ \|_ _/ _ \|  _ \|_ _|_   _\ \ / /
prompt |   | |  \  /|  \| | | |_) | |_) || | | | | |_) || |  | |  \ V / 
prompt |   | |  /  \| |\  | |  __/|  _ < | | |_| |  _ < | |  | |   | |  
prompt |   |_| /_/\_\_| \_| |_|   |_| \_\___\___/|_| \_\___| |_|   |_|  
prompt |                                                                
prompt |
prompt |
prompt |
pause
clear screen
set termout on
set echo on
grant db_developer_role to lazy_joe
identified by lazy_joe;
pause
grant db_developer_role to daily_pay_run
identified by daily_pay_run;
pause
grant all on scott.emp to lazy_joe;
grant all on scott.emp to daily_pay_run;
pause
clear screen
conn lazy_joe/lazy_joe@db23
update scott.emp
set sal = sal + 10
where empno = 7369;
rem
rem over to session 2 (10a)
rem
pause
roll;
pause
clear screen
conn sys/SYSTEM_PASSWORD@db23
pause
alter system set priority_txns_high_wait_target = 6;
pause
conn lazy_joe/lazy_joe@db23
alter session set txn_priority = low;
pause
update scott.emp
set sal = sal + 10
where empno = 7369;
rem
rem over to session 2
rem
pause
select * from dual;
pause
rollback;
pause
set echo off
clear screen
conn dbdemo/dbdemo@db23
clear screen
set echo on
show parameter txn_auto_rollback_mode
pause
select name
from v$sysstat
where name like 'txns%';
pause
clear screen
REM conn daily_pay_run/daily_pay_run@db23
set termout off
set echo off
set termout on
prompt |
prompt |  ____  _____ ____ _   _ ____  ___ _______   __
prompt | / ___|| ____/ ___| | | |  _ \|_ _|_   _\ \ / /
prompt | \___ \|  _|| |   | | | | |_) || |  | |  \ V / 
prompt |  ___) | |__| |___| |_| |  _ < | |  | |   | |  
prompt | |____/|_____\____|\___/|_| \_\___| |_|   |_|  
prompt |                                               
prompt |
pause
set echo on
alter user daily_pay_run identified by ORomeoRomeowhereforeartthouRomeoDenythyfatherandrefusethynameOrifthouwiltnotbebutswornmyloveAndIllnolongerbeaCapuletTisbutthynamethatismyenemyThouartthyselfthoughnotaMontagueWhatsMontagueItisnorhandnorfootNorarmnorfacenoranyotherpartBelongingtoamanObesomeothernameWhatsinanameThatwhichwecallaroseByanyothernamewouldsmellassweetSoRomeowouldwerehenotRomeocalldRetainthatdearperfectionwhichheowesWithoutthattitleRomeodoffthynameAndforthatnamewhichisnopartoftheeTakeallmyself

/

pause Done
