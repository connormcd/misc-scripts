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
clear screen
set termout on
set echo off
prompt |
prompt |  ____  _____ ____  _____ ______     ___    ____  _     _____ 
prompt | |  _ \| ____/ ___|| ____|  _ \ \   / / \  | __ )| |   | ____|
prompt | | |_) |  _| \___ \|  _| | |_) \ \ / / _ \ |  _ \| |   |  _|  
prompt | |  _ <| |___ ___) | |___|  _ < \ V / ___ \| |_) | |___| |___ 
prompt | |_| \_\_____|____/|_____|_| \_\ \_/_/   \_\____/|_____|_____|
prompt |                                                              
pause

set echo on
set lines 60
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
select * from user_triggers
where table_name = 'T';
pause
select * from user_synonyms
where synonym_name = 'T';
pause
select * from user_policies
where object_name = 'T';
pause
select * from dba_sql_patches
where sql_text like 'update%';
pause
clear screen
update t set col = col + 1
where pk = 1;
--
-- session 2 (42a)
--
pause
select * from t;
pause
commit;
pause
select * from t;
pause
set lines 120
set echo off
clear screen
prompt |   
prompt |     +------------+     +-----------+
prompt |     |            |     |           |
prompt |     |  CUSTOMER  |     | PRODUCTS  |
prompt |     |            |     |           |
prompt |     +------------+     +-----------+
prompt |            |                 |
prompt |            |                 |
prompt |           /|\               /|\
prompt |     +--------------------------------+
prompt |     |                                |
prompt |     |            ORDERS              |
prompt |     |                                |
prompt |     +--------------------------------+
prompt |  
pause
set echo on
clear screen

set echo on
set termout on
create table customer ( 
  customer_id   int primary key,
  email_address varchar2(30),
  full_name     varchar2(30),
  total_orders  int
); 
pause
insert into customer 
values (1,'connor@oracle.com','Connor McDonald',0);
insert into customer 
values (2,'suzy@oracle.com','Suzy Ellison',0);
pause
clear screen
create table products
  ( prod_name  varchar2(20) primary key,
    total_sold int);
pause
insert into products values ('Phone',0);
insert into products values ('Laptop',0);
insert into products values ('TV',0);
pause
select * from products;
commit;
pause
clear screen
create table orders (
  order_id       int primary key,
  order_datetime date,
  customer_id    int  references customer ( customer_id ),
  product        varchar2(20)  references products ( prod_name ),
  amt            int
);
pause
clear screen
--
-- 'new order' app
--
begin
  insert into orders
  values(12,sysdate,1,'Phone',5);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 1;

  update products
  set    total_sold = total_sold + 5
  where  prod_name = 'Phone';
end;
/
commit;
pause
clear screen
begin
  insert into orders
  values(13,sysdate,1,'TV',3);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 1;

  update products
  set    total_sold = total_sold + 3
  where  prod_name = 'TV';
end;
/
pause
select * from customer;
pause
select * from products;
rem
rem -- over to session 2
rem
pause
commit;
pause
select * from products;
rem
rem -- over to session 2
rem 
pause
clear screen
alter table products
  modify total_sold reservable;
pause
select * from products;
pause
begin
  insert into orders
  values(14,sysdate,1,'Laptop',4);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 1;

  update products
  set    total_sold = total_sold + 4
  where  prod_name = 'Laptop';
end;
/
rem
rem -- over to session 2
rem 
pause
commit;
pause
select * from products;
pause
select table_name journal
from   user_tables
where  table_name like 'SYS%'||
  ( select object_id
    from   user_objects
    where  object_name = 'PRODUCTS' );
pause
set lines 70
desc &&journal_table
pause
clear screen
begin
  insert into orders
  values(30,sysdate,1,'Phone',8);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 1;

  update products
  set    total_sold = total_sold + 8
  where  prod_name = 'Phone';
end;
/
pause
select * from &&journal_table;
pause
roll;
pause
drop table orders purge;
drop table products purge;

pause Done
