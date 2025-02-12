REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn SYS_USER/PASSWORD@MY_PDB
set termout off
alter table t modify col not reservable;
@drop customer
@drop orders
@drop products
@drop t
col journal new_value journal_table
col journal format a30
set verify off
create table t ( pk int primary key, col int reservable);
insert into t values (1,10);
commit;
set termout on
set echo on
set lines 60
clear screen
desc t
pause
show user
pause
select global_name from global_name;
pause
select * from user_triggers
where table_name = 'T';
pause
clear screen
select * from t;
pause
update t set col = col + 3
where pk = 1;
--
-- session 2
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
  ( prod_name  varchar2(20) primary key , 
    total_sold int);
pause
insert into products values ('Phone',0);
insert into products values ('Laptop',0);
insert into products values ('TV',0);
commit;
pause
clear screen
create table orders (
  order_id        int primary key,
  order_datetime  date default sysdate,
  customer_id     int 
    references customer ( customer_id ),
  product         varchar2(20)  
    references products ( prod_name ),
  qty int
);
pause
clear screen
--
-- 'new order' application
--
begin
  insert into orders 
    (order_id,customer_id,product,qty)
  values
    (12,1,'Phone',5);
  
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
    (order_id,customer_id,product,qty)
  values
    (13,1,'TV',3);
  
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
    (order_id,customer_id,product,qty)
  values
    (14,1,'Laptop',4);
  
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
    (order_id,customer_id,product,qty)
  values
    (30,1,'Phone',8);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 1;

  update products
  set    total_sold = total_sold + 8
  where  prod_name = 'Phone';
end;
/

begin
  insert into orders
  values(31,sysdate,1,'Phone',7);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 1;

  update products
  set    total_sold = total_sold + 7
  where  prod_name = 'Phone';
end;
/
pause
select * from &&journal_table;
pause
select * from products;
pause
commit;
select * from products;
