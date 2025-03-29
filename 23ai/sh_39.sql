clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set long 1000
clear screen
@drop t
@drop jc
drop view jdv;
@drop JDV_CUSTOMER_INFO
@drop JDV_ORDER_ITEMS
@drop JDV_ROOT
set termout on
set echo off
prompt | 
prompt |        _  _____  ____  _   _      __  __ _____ _____ _____         _______ _____ ____  _   _ 
prompt |       | |/ ____|/ __ \| \ | |    |  \/  |_   _/ ____|  __ \     /\|__   __|_   _/ __ \| \ | |
prompt |       | | (___ | |  | |  \| |    | \  / | | || |  __| |__) |   /  \  | |    | || |  | |  \| |
prompt |   _   | |\___ \| |  | | . ` |    | |\/| | | || | |_ |  _  /   / /\ \ | |    | || |  | | . ` |
prompt |  | |__| |____) | |__| | |\  |    | |  | |_| || |__| | | \ \  / ____ \| |   _| || |__| | |\  |
prompt |   \____/|_____/ \____/|_| \_|    |_|  |_|_____\_____|_|  \_\/_/    \_\_|  |_____\____/|_| \_|
prompt |                                                                                              
prompt |                                                                                              
set echo on
pause
clear screen
create json collection table jc;
pause
begin
 insert into jc values('
{
    "CustomerId" : 1,
    "CustomerName" : "Connor McDonald",
    "CustomerEmail" : "connor@oracle.com"
  }');
end;
/
pause
select * from jc;
pause
begin
 insert into jc values('
{
    "_id" : 10,
    "CustomerName" : "Larry McDonald",
    "CustomerEmail" : "connor@oracle.com"
  }');
end;
/
pause
select * from jc;
pause
set echo off
prompt |
prompt |
prompt | Um....yeah "wow"
prompt |
prompt |
pause
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
pause
clear screen
prompt | create or replace json relational duality view orders_ov as
prompt | select 
prompt |   json {'_id'     : ord.order_id, 
prompt |         'OrderTime'   : ord.order_datetime,
prompt |         'OrderStatus' : ord.order_status,
prompt |         'CustomerInfo' : 
prompt |           ( select json{'CustomerId'    : cust.customer_id,
prompt |                         'CustomerName'  : cust.full_name,
prompt |                         'CustomerEmail' : cust.email_address }       
prompt |            from customer cust with update 
prompt |            where cust.customer_id = ord.customer_id
prompt |           ), 
prompt |           'OrderItems' : 
prompt |           [ select json { 'OrderItemId' : oi.line_item_id,
prompt |                           'Quantity'    : oi.quantity,     
prompt |                           'Product'     : oi.product_name }
prompt |             from order_items oi  with insert update  
prompt |             where ord.order_id = oi.order_id
prompt |           ] 
prompt | } 
prompt | from orders ord with insert update delete;
prompt | 
pause
set echo on
drop table jc purge;
create json collection table jc;
pause
begin
 insert into jc values('
{
  "_id" : 30,
  "OrderTime" : "2022-11-17T00:11:00",
  "OrderStatus" : "NEW",
  "CustomerInfo" :
  {
    "CustomerId" : 1,
    "CustomerName" : "Connor McDonald",
    "CustomerEmail" : "connor@oracle.com"
  },
  "OrderItems" :
  [
    {
      "OrderItemId" : 300,
      "Quantity" : 2,
      "Product" : "Fridge"
    },
    {
      "OrderItemId" : 301,
      "Quantity" : 1,
      "Product" : "Stove"
    }
  ]
}');
end;
/
pause
clear screen
variable c clob
begin
  :c := dbms_json_duality.infer_and_generate_schema(
          json('{"tableNames":["JC" ],
                 "viewNames" :[ "JDV"], 
                 "useFlexFields":false }'));
end;
/
pause
set long 50000
print c
pause
exec execute immediate :c
pause
select table_name from user_tables
where table_name like 'JDV%';
pause Done
