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
alter table t modify col not reservable;
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

col EMAIL_ADDRESS    format a18             
col FULL_NAME format a18

create table t ( pk int primary key, col int reservable);
insert into t values (1,10);
commit;
set termout on
set echo on
set lines 70
clear screen
desc t
pause
show user
pause
select global_name from global_name;
pause
clear screen
select * from t;
pause
update t set col = col + 3
where pk = 1;
pause
select xid from v$transaction;
--
-- session 2
--
pause
select * from t;
pause
commit;
pause
select * from t;
