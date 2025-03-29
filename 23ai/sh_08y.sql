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
alter table emp modify deptno null;
@drop job_details
drop view emp_js;

drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
@drop customer
@drop orders
@drop orderitems
drop view orders_ov;
@dropc order_items
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
set long 50000

clear screen
set termout on
set echo off
prompt |
prompt |      _ ____   ___  _   _   ____  _   _   _    _     ___ _______   __
prompt |     | / ___| / _ \| \ | | |  _ \| | | | / \  | |   |_ _|_   _\ \ / /
prompt |  _  | \___ \| | | |  \| | | | | | | | |/ _ \ | |    | |  | |  \ V / 
prompt | | |_| |___) | |_| | |\  | | |_| | |_| / ___ \| |___ | |  | |   | |  
prompt |  \___/|____/ \___/|_| \_| |____/ \___/_/   \_\_____|___| |_|   |_|  
prompt |                                                                     
prompt |
pause
set echo on
clear screen
set termout on
create or replace json duality view emp_js as
select 
json {
  '_id' : empno,
  'ename' : ename,
  'sal'   : sal,
  'hiredate' : hiredate,
  'deptno' : deptno
  }
from emp;
pause
set echo off
prompt |
prompt |  "Um....big deal?"
prompt |
pause
set echo on 
clear screen
create or replace json duality view emp_js as
select 
json {
  '_id' : empno,
  'ename' : ename,
  'sal'   : sal,
  'hiredate' : hiredate,
  'deptno' : deptno
  }
from emp
with (update,insert,delete);
pause
set lines 60
clear screen
desc emp_js
pause
set lines 120
select data  
from emp_js e
where e.data."_id" = 7369;
pause
select json_serialize(data pretty) 
from emp_js e
where e.data."_id" = 7369;
pause
clear screen
update emp
set sal = sal + 99
where empno = 7369;
pause
select json_serialize(data pretty) 
from emp_js e
where e.data."_id" = 7369;
pause
clear screen
insert into emp_js
values (
'{
  "_id" : 8000,
  "ename" : "CONNOR",
  "sal" : 1000,
  "hiredate" : "1980-12-17T00:00:00",
  "deptno" : 20
}');
pause
select * from emp
order by empno;
pause
roll;
pause
clear screen
update emp_js e
set data = 
'{
  "_metadata" :
  {
    "etag" : "DFE10C3EBE1BE0C0071C036A30199975",
    "asof" : "00000000004FFE10"
  },
  "_id" : 7369,
  "ename" : "SMITH",
  "sal" : 500,
  "hiredate" : "1980-12-17T00:00:00",
  "deptno" : 20
}'
where e.data."_id" = 7369;
pause
select * from emp
where empno = 7369;
pause
clear screen
select json_serialize(data pretty) 
from emp_js e
where e.data."_id" = 7369;
pause
--
-- fails because new etag
--
update emp_js e
set data = 
'{
  "_metadata" :
  {
    "etag" : "DFE10C3EBE1BE0C0071C036A30199975",
    "asof" : "00000000004FFE10"
  },
  "_id" : 7369,
  "ename" : "SMITH",
  "sal" : 500,
  "hiredate" : "1980-12-17T00:00:00",
  "deptno" : 20
}'
where e.data."_id" = 7369;
pause
roll;
pause
clear screen
-- graph as well
--
pause
select e.deptno, e."_id", e.ename, e.sal, d.dname
from emp e, dept d
where e.deptno = d.deptno
order by 1,2;
pause
clear screen
create or replace json duality view dept_js as
dept
{
   DeptNum : deptno,
   DeptName: dname,
   emps: emp @insert @update @delete
   {
      empID: empno,
      empName: ename,
      empSal: sal
   }
};
pause
clear screen
select json_serialize(data pretty) 
from dept_js d
where d.data.DeptNum = 10;
pause
set echo off
clear screen
prompt |
prompt |   +------------+
prompt |   |            |
prompt |   |  CUSTOMER  |
prompt |   |            |
prompt |   +------------+
prompt |          |   
prompt |          |
prompt |         /|\
prompt |   +------------+
prompt |   |            |
prompt |   |  ORDERS    |
prompt |   |            |
prompt |   +------------+
prompt |          |   
prompt |          |
prompt |         /|\
prompt |   +-----------------+
prompt |   |                 |
prompt |   |  ORDER_ITEMS    |
prompt |   |                 |
prompt |   +-----------------+
prompt |
set echo on
pause
clear screen
create table customer ( 
  customer_id int primary key,
  email_address varchar2(30),
  full_name varchar2(30)
); 
pause
insert into customer 
values (1,'connor@oracle.com','Connor MacDonald');
pause
clear screen
create table orders (
  order_id int primary key,
  order_datetime    date,
  order_status   varchar2(10),
  customer_id int  references customer ( customer_id )
);
pause
insert into orders
values (10,sysdate-1,'SHIPPED',1);
pause
insert into orders
values (20,sysdate,'NEW',1);
pause
clear screen
create table order_items (
  line_item_id int primary key,
  order_id  int references orders ( order_id ),
  quantity int,
  product_name varchar2(20)
);
pause
insert into order_items
values (100,10,1,'Phone');
pause
insert into order_items
values (200,20,1,'TV');
pause
clear screen
create or replace json relational duality view orders_ov as
select 
  json {'_id'     : ord.order_id, 
        'OrderTime'   : ord.order_datetime,
        'OrderStatus' : ord.order_status,
        'CustomerInfo' : 
          ( select json{'CustomerId'    : cust.customer_id,
                        'CustomerName'  : cust.full_name,
                        'CustomerEmail' : cust.email_address }       
           from customer cust with update 
           where cust.customer_id = ord.customer_id
          ), 
          'OrderItems' : 
          [ select json { 'OrderItemId' : oi.line_item_id,
                          'Quantity'    : oi.quantity,     
                          'Product'     : oi.product_name }
            from order_items oi  with insert update  
            where ord.order_id = oi.order_id
          ] 
} 
from orders ord with insert update delete;
pause
clear screen
select json_serialize(data pretty)
from orders_ov;
pause
clear screen
insert into order_items
values (201,20,1,'Laptop');
pause
select json_serialize(data pretty)
from orders_ov;
pause
clear screen
update orders_ov t
set data =
  json_transform(
    data,
    set '$.CustomerInfo.CustomerName' = 'Connor McDonald')
where t.data."_id" = 10;
pause
select json_serialize(data pretty)
from orders_ov;
pause
select * from customer;
pause
clear screen
update orders_ov t
set data =
  json_transform(
    data,
    append '$.OrderItems' = json('{
      "OrderItemId" : 202,
      "Quantity" : 1,
      "Product" : "Microwave"
    }'))
where t.data."_id" = 20;
pause
select json_serialize(data pretty)
from orders_ov;
pause
select * 
from order_items
where order_id = 20;
pause
clear screen
declare
  l_json json := json('
{
  "_id" : 30,
  "OrderTime" : "2022-11-17T00:11:00",
  "OrderStatus" : "NEW",
  "CustomerInfo" :
  { "CustomerId" : 1,
    "CustomerName" : "Connor McDonald",
    "CustomerEmail" : "connor@oracle.com"
  },
  "OrderItems" :
  [ { "OrderItemId" : 300,
      "Quantity" : 2,
      "Product" : "Fridge"  },
    { "OrderItemId" : 301,
      "Quantity" : 1,
      "Product" : "Stove"    }
  ]
}');
begin
 insert into orders_ov
 values (l_json);
end;
/
pause
select * 
from orders;
pause
select * 
from order_items;


pause Done
