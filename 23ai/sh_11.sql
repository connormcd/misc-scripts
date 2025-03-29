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
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |  ____   ___  _          _    _   _    _    _  __   ______ ___ ____  
prompt | / ___| / _ \| |        / \  | \ | |  / \  | | \ \ / / ___|_ _/ ___| 
prompt | \___ \| | | | |       / _ \ |  \| | / _ \ | |  \ V /\___ \| |\___ \ 
prompt |  ___) | |_| | |___   / ___ \| |\  |/ ___ \| |___| |  ___) | | ___) |
prompt | |____/ \__\_\_____| /_/   \_\_| \_/_/   \_\_____|_| |____/___|____/ 
prompt |                                                                     
pause
set echo on

set echo on
set termout on
create table t1 as 
select * from dba_objects
where object_id is not null;
create table t2 as 
select * from dba_objects;
pause
clear screen
explain plan for
select max(t1.object_id)
from t1,t2;
pause

select *
from dbms_xplan.display();
pause
clear screen
create index ix on t1 ( created );
pause

explain plan for
select *
from t1
where trunc(created) = trunc(sysdate);
pause

select *
from dbms_xplan.display();
pause
clear screen
explain plan for
select *
from t1
union
select *
from t2;
pause

select *
from dbms_xplan.display();

pause Done
