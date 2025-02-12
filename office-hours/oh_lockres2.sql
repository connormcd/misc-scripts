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
update t set col = col + 1
where pk = 1


pause
/
pause
commit;
--
-- session 1
--
pause
set lines 120
clear screen
begin
  insert into orders 
    (order_id,customer_id,product,qty)
  values
    (21,2,'Laptop',10);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 2;

  update products
  set    total_sold = total_sold + 10
  where  prod_name = 'Laptop';
end;
/
pause
clear screen
begin
  insert into orders 
    (order_id,customer_id,product,qty)
  values
    (22,2,'TV',3);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 2;

  update products
  set    total_sold = total_sold + 3
  where  prod_name = 'TV';
end;
/
pause
commit;
REM
REM -- back to session 1
REM
pause
clear screen
begin
  insert into orders 
    (order_id,customer_id,product,qty)
  values
    (23,2,'Laptop',5);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 2;

  update products
  set    total_sold = total_sold + 5
  where  prod_name = 'Laptop';
end;
/
pause
commit;
pause
select * from products;
