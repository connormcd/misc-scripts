clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
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
  values(21,sysdate,2,'Laptop',10);
  
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
  values(22,sysdate,2,'TV',7);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 2;

  update products
  set    total_sold = total_sold + 7
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
  values(23,sysdate,2,'Laptop',4);
  
  update customer
  set    total_orders = total_orders + 1
  where  customer_id = 2;

  update products
  set    total_sold = total_sold + 4
  where  prod_name = 'Laptop';
end;
/
pause
commit;
pause
select * from products;
