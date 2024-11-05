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
clear screen
set timing off
create or replace
function very_complex_java_web_service(p_row sales%rowtype default null) return boolean is
begin
  return true;
end;
/

@drop products
@drop customers
@drop sales
@drop sales_low

set termout off
set timing off
set pages 999
set termout on
clear screen
set echo on
create table products as
select rownum pid, 'product '||rownum descr
from dual
connect by level <= 100;
pause
create table customers as
select rownum cid, 'customer '||rownum name
from dual
connect by level <= 1000;
pause
clear screen
create table sales as
with cust_prod as 
(
select /*+ materialize */ 
  trunc(dbms_random.value(1,100)) pid,
  trunc(dbms_random.value(1,1000)) cid
from dual
connect by level <= 10000 
)
select 
  pid, 
  cid, 
  date '2020-01-01' + rownum/86400 tstamp,
  mod(rownum,10) amount,
  mod(rownum,100) tot_price
from cust_prod,
  ( select 1 from dual connect by level <= 150 );
pause
create index sales_ix on sales ( pid,cid );
pause
clear screen
create table sales_low
( pid int,
  cid int,
  tstamp date,
  amount int,
  price  int,
  detected date );
pause
--
-- API to log an excessively low sale
--
create or replace
procedure log_low_sale(p_row sales%rowtype) is
begin
  insert into sales_low
  values (
    p_row.pid,
    p_row.cid,
    p_row.tstamp,
    p_row.amount,
    p_row.tot_price,
    sysdate);
  commit;
end;
/
pause
clear screen
--
-- API to find low sales for cust/product pair
--
create or replace
procedure find_low_sales(
    p_pid int, 
    p_cid int,
    p_tot out int) is
    
  cursor c_sales is
     select * from sales
     where amount < 4
     and   cid = p_cid
     and   pid = p_pid;

   l_row c_sales%rowtype;     
   l_tot int := 0;
begin
  open c_sales;
  loop
    fetch c_sales into l_row;
    exit when c_sales%notfound;
    
    if very_complex_java_web_service(l_row) then
      l_tot := l_tot + 1;
      log_low_sale(l_row);
    end if;               
  end loop;
  close c_sales;
end;
/
pause
clear screen
set timing on
declare
  cursor c_prod_list is
     select pid from products;
  cursor c_cust_list is
     select cid from customers;

  l_pid int;
  l_cid int;
  l_tot int;
begin
  open c_prod_list;
  loop
    fetch c_prod_list into l_pid;
    exit when c_prod_list%notfound;
    
    open c_cust_list;
    loop
      fetch c_cust_list into l_cid;
      exit when c_cust_list%notfound;
      
      find_low_sales(l_pid,l_cid,l_tot);
    end loop;
    close c_cust_list;
    
  end loop;    
  close c_prod_list;
end;
/
set timing off
pause
clear screen
create or replace
procedure log_low_sale(p_row sales%rowtype) is
begin
  insert into sales_low
  values (
    p_row.pid,
    p_row.cid,
    p_row.tstamp,
    p_row.amount,
    p_row.tot_price,
    sysdate);
  --commit;
end;
/
pause
clear screen
set timing on
declare
  cursor c_prod_list is
     select pid from products;
  cursor c_cust_list is
     select cid from customers;

  l_pid int;
  l_cid int;
  l_tot int;
begin
  open c_prod_list;
  loop
    fetch c_prod_list into l_pid;
    exit when c_prod_list%notfound;
    
    open c_cust_list;
    loop
      fetch c_cust_list into l_cid;
      exit when c_cust_list%notfound;
      
      find_low_sales(l_pid,l_cid,l_tot);
    end loop;
    close c_cust_list;
    
  end loop;    
  close c_prod_list;
  commit;
end;
/
pause
set timing off
clear screen
--
-- the "myth" of restart
--
pause
create or replace
package commit_every is
  procedure five_secs;
end;
/
pause
create or replace
package body commit_every is
  last_commit date := sysdate;

  procedure five_secs is
  begin
    if sysdate-last_commit > 5/86400 then
      commit;
      last_commit := sysdate;
    end if;
  end;
end;
/
pause
clear screen
create or replace
procedure log_low_sale(p_row sales%rowtype) is
begin
  insert into sales_low
  values (
    p_row.pid,
    p_row.cid,
    p_row.tstamp,
    p_row.amount,
    p_row.tot_price,
    sysdate);
  commit_every.five_secs;
end;
/
pause
clear screen
set timing on
declare
  cursor c_prod_list is
     select pid from products;
  cursor c_cust_list is
     select cid from customers;

  l_pid int;
  l_cid int;
  l_tot int;
begin
  open c_prod_list;
  loop
    fetch c_prod_list into l_pid;
    exit when c_prod_list%notfound;
    
    open c_cust_list;
    loop
      fetch c_cust_list into l_cid;
      exit when c_cust_list%notfound;
      
      find_low_sales(l_pid,l_cid,l_tot);
    end loop;
    close c_cust_list;
    
  end loop;    
  close c_prod_list;
  commit;
end;
/
set timing off
pause
clear screen
create or replace
procedure find_low_sales(
    p_pid int, 
    p_cid int,
    p_tot out int) is
    
  cursor c_sales is
     select * from sales
     where amount < 4
     and   cid = p_cid
     and   pid = p_pid;

   l_tot int := 0;
begin
--  open c_sales;
--    fetch c_sales into l_row;
--    exit when c_sales%notfound;

  for l_row in c_sales
  loop
    if very_complex_java_web_service(l_row) then
      l_tot := l_tot + 1;
      log_low_sale(l_row);
    end if;               
  end loop;
end;
/
pause
clear screen
set timing on
declare
  cursor c_prod_list is
     select pid from products;
  cursor c_cust_list is
     select cid from customers;

  l_pid int;
  l_cid int;
  l_tot int;
begin
--  open c_prod_list;
--    fetch c_prod_list into l_pid;
--    exit when c_prod_list%notfound;

  for p in c_prod_list 
  loop

    --  open c_cust_list;
    --    fetch c_cust_list into l_cid;
    --    exit when c_cust_list%notfound;

    for c in c_cust_list
    loop
      find_low_sales(p.pid,c.cid,l_tot);
    end loop;
  end loop;    
  commit;
end;
/
set timing off
pause
clear screen
create or replace
package pending_rows is
  type row_list is table of sales_low%rowtype 
    index by pls_integer;
  l_pending row_list;
  
  procedure insert_into_sales_low(
      p_pid int,
      p_cid int,
      p_tstamp date,
      p_amount int,
      p_tot_price int);

  procedure flush;
end;
/
pause
clear screen
create or replace
package body pending_rows is
  procedure insert_into_sales_low(
      p_pid int,
      p_cid int,
      p_tstamp date,
      p_amount int,
      p_tot_price int) is
    l_row sales_low%rowtype;
  begin
    l_row.pid := p_pid;
    l_row.cid := p_cid;
    l_row.tstamp := p_tstamp;
    l_row.amount := p_amount;
    l_row.price := p_tot_price;
    l_row.detected := sysdate;
    
    l_pending(l_pending.count+1) := l_row;
    if l_pending.count > 1000 then
      flush;
    end if;
  end;
  
  procedure flush is
  begin
    forall i in 1 .. l_pending.count
       insert into sales_low values l_pending(i);
    l_pending.delete;
  end;
end;
/
pause
clear screen
create or replace
procedure log_low_sale(p_row sales%rowtype) is
begin
  --
  --insert into sales_low values (
  --
  pending_rows.insert_into_sales_low
   (
    p_row.pid,
    p_row.cid,
    p_row.tstamp,
    p_row.amount,
    p_row.tot_price);
  commit_every.five_secs;
end;
/
pause
set timing on
declare
  cursor c_prod_list is
     select pid from products;
  cursor c_cust_list is
     select cid from customers;

  l_pid int;
  l_cid int;
  l_tot int;
begin
  for p in c_prod_list 
  loop
    for c in c_cust_list
    loop
      find_low_sales(p.pid,c.cid,l_tot);
    end loop;
  end loop;    
  pending_rows.flush;
  commit;
end;
/
set timing off
pause
clear screen
create or replace
function bool_to_int return int is
  pragma udf;
begin
  return
    case when very_complex_java_web_service then 1 else 0 end;
end;
/
pause
set timing on
insert into sales_low
select pid,cid,tstamp,amount,tot_price,sysdate
from sales
where amount < 4
and bool_to_int = 1;
set timing off
commit;
