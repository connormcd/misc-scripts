REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set echo off
set termout off
conn / as sysdba
set termout off

--
-- we don't want results biased by a log switch in the middle of things or
-- differences in buffer cache etc, so we flush everything
--
alter system archive log current;
alter system checkpoint;

conn /@YOURDB as sysdba
set termout off

--
-- we have to turn off dynamic sequencing in order to show its benefit later
--
alter system set "_dynamic_sequence_cache" = false;

conn ogb/ogb@YOURDB
set termout off
alter session set "_dynamic_sequence_cache" = false;
--
-- baseline, triggers plus indexes plus bad seq
--
@drop results
@drop customers
@drop order_items
@drop orders
@drop product_categories
@drop products

@drop customers_seq;
@drop product_seq;
@drop orders_seq;

clear screen
@clean
set echo on
create table customers (
    customer_id    integer not null,
    customer_ssn   varchar2(20 char) not null,
    customer_name  varchar2(100 char) not null,
    created_by     varchar2(128) not null
);

alter table customers add constraint customer_pk primary key ( customer_id );
alter table customers add constraint customer_ssn_u unique ( customer_ssn );

create table product_categories (
    category_name varchar2(20) not null
);

alter table product_categories add constraint product_categories_pk primary key ( category_name );
pause
clear screen
create table products (
    product_id                integer not null,
    product_description_json  clob not null check ( product_description_json is json ),
    price                     number not null,
    category_name             varchar2(20) not null,
    product_name              varchar2(100) not null
);
alter table products add constraint products_pk primary key ( product_id );
pause

create table orders (
    order_id        integer not null,
    order_datetime  date not null,
    customer_id     integer not null,
    created_by      varchar2(128) not null
);

alter table orders add constraint order_pk primary key ( order_id );
create index orders_ix1 on orders ( customer_id );
pause
clear screen
create table order_items (
    order_id    integer not null,
    product_id  integer not null,
    quantity    integer not null,
    unit_price  number(10, 2) not null,
    created_by     varchar2(128) not null
);

alter table order_items add constraint order_items_pk 
  primary key ( order_id, product_id );

create index order_items_ix1 on order_items ( order_id );
create index order_items_ix2 on order_items ( product_id );
pause
clear screen
alter table orders
    add constraint order_customer_fk foreign key ( customer_id )
        references customers ( customer_id );

alter table order_items
    add constraint order_items_order_fk foreign key ( order_id )
        references orders ( order_id );

alter table order_items
    add constraint order_items_products_fk foreign key ( product_id )
        references products ( product_id );

alter table products
    add constraint products_product_categories_fk foreign key ( category_name )
        references product_categories ( category_name );
pause
clear screen
create sequence customers_seq;
create sequence product_seq;
create sequence orders_seq;
pause
clear screen

create or replace
trigger customer_trg 
before insert on customers
for each row
begin
  if :new.customer_id is null then
     :new.customer_id := customers_seq.nextval;
  end if;
  
  if :new.created_by is null then
     :new.created_by := user;
  end if;
end;
/
pause
clear screen

create or replace
trigger orders_trg 
before insert on orders
for each row
begin
  if :new.order_id is null then
     :new.order_id := orders_seq.nextval;
  end if;

  if :new.order_datetime is null then
     :new.order_datetime := sysdate;
  end if;
  
  if :new.created_by is null then
     :new.created_by := user;
  end if;
end;
/
pause
clear screen
create or replace
trigger order_items_trg 
before insert on order_items
for each row
begin
  if :new.created_by is null then
     :new.created_by := user;
  end if;
end;
/
pause
clear screen

insert into customers ( customer_ssn ,customer_name )
select 'custssn'||rownum, 'customer'||rownum
from dual
connect by level <= 5000;
insert into product_categories
select 'cat'||rownum
from dual
connect by level <= 20;
insert into products 
select rownum,
       '{"product":"my product'||rownum||'"}',
       round(dbms_random.value(10,40),2),
       'cat'||(mod(rownum,20)+1),
       'product'||rownum
from dual
connect by level <= 1000;
commit;
pause
clear screen
create or replace 
procedure new_order(p_customer_id int, 
                    p_order_id out int) is
begin
  insert into orders ( customer_id)
  values ( p_customer_id)
  returning order_id into p_order_id;
end;
/
create or replace 
procedure new_customer(p_customer_ssn varchar2,
                       p_customer_name varchar2,
                       p_cust_id out int) is
begin
  insert into customers ( customer_ssn ,customer_name )
  values ( p_customer_ssn ,p_customer_name )
  returning customer_id into p_cust_id;
end;
/
pause
create or replace
procedure new_order_item(p_order_id int, p_product_id int, p_quantity int, p_unit_price number ) is
begin
  insert into order_items (order_id,product_id,quantity,unit_price)
  values (p_order_id,p_product_id,p_quantity,p_unit_price);
end;
/
pause
clear screen
create table results as select rownum-1 seed, 0 tps, 0 ela from dual
connect by level <= 10;
pause

create or replace 
package benchmark is
  iter     int := 40000;  -- ORDERS TO PLACE
  new_cust int := 200;     -- NEW CUST EVERY 200 ORDERS 

  rnd  int := 50000;
  idx  int;
  seed int;
  l_start timestamp;
  
  l_order_id int;
  l_cust_id int;
  type numlist is table of number
    index by pls_integer;

  type charlist is table of varchar2(20)
    index by pls_integer;
  
  l_cust      numlist;
  l_prod      numlist;
  l_cat       charlist;
  l_item_cnt  numlist;
  l_lock      int;

  procedure init(p_seed int);
  procedure run(p_seed int);
end;
/
pause
clear screen

create or replace 
package body benchmark is

procedure init(p_seed int) is
begin  
  seed := p_seed;
  dbms_random.seed(p_seed);
  
  select mod(rownum,5000)+1 bulk collect into l_cust 
  from dual connect by level <= rnd
  order by dbms_random.value;

  select mod(rownum,1000)+1 bulk collect into l_prod 
  from dual connect by level <= rnd+10
  order by dbms_random.value;

  select 'cat'||(mod(rownum,20)+1) bulk collect into l_cat 
  from dual connect by level <= rnd
  order by dbms_random.value;

  select mod(rownum,10)+1 bulk collect into l_item_cnt 
  from dual connect by level <= rnd
  order by dbms_random.value;
end;

procedure run(p_seed int) is  
begin
  l_start := systimestamp;
  for i in 1 .. iter
  loop
    idx := mod(iter,rnd)+1;
    if mod(i,new_cust) = 0 then
       new_customer('ssn'||(i*10+seed),'newname'||(i*10+seed),l_cust_id);
       new_order(l_cust_id, l_order_id);
    else
        new_order(l_cust(idx), l_order_id);
    end if;
    
    for j in 1 .. mod(i,5)+1
    loop
      new_order_item(l_order_id, l_prod(idx+j), j, j );
    end loop;
    commit;
  end loop;
  update results 
    set tps = round(iter / extract(second from (systimestamp-l_start)),1),
        ela = extract(second from (systimestamp-l_start))
  where seed = p_seed;
  commit;
end;

end;
/
pause
clear screen

conn ogb/ogb@YOURDB
lock table results in exclusive mode;
pause

host start sql_plus @c:\oracle\sql\ogb_bench.sql 0
host start sql_plus @c:\oracle\sql\ogb_bench.sql 1
host start sql_plus @c:\oracle\sql\ogb_bench.sql 2
host start sql_plus @c:\oracle\sql\ogb_bench.sql 3
host start sql_plus @c:\oracle\sql\ogb_bench.sql 4
host start sql_plus @c:\oracle\sql\ogb_bench.sql 5
REM
REM Nothing starts until I commit
REM
pause
commit;

REM
REM Waiting for benchmark to finish
REM
set echo off
declare
  x int;
begin
  loop
    select count(*) into x
    from   results
    where  tps > 0;
    
    exit when x = 6;
    dbms_session.sleep(2);
  end loop;
end;
/
pro
pro All completed!
pro
set echo on
clear screen
set echo off
set lines 200
col event format a44 TRUNC
col pct format a10
select min(ela), max(ela), avg(ela) from results where ela != 0;
select sum(tps) from results;
select * from 
(
  select EVENT
  ,TOTAL_WAITS
  ,TOTAL_TIMEOUTS
  ,SECS
  ,rpad(to_char(100 * ratio_to_report(secs) over (), 'FM00.00') || '%',8)  pct
  from (
  select EVENT
  ,sum(TOTAL_WAITS) TOTAL_WAITS
  ,sum(TOTAL_TIMEOUTS) TOTAL_TIMEOUTS
  ,sum(TIME_WAITED/100) SECS
  from v$session_event
  where sid != sys_context('USERENV','SID') 
  and event not like 'SQL*Net%'
  and event != 'enq: TM - contention'
  and sid in ( select sid from v$session where username = 'OGB')
  group by event
  union all
  select 'CPU', null, null, sum(value/100) from v$sesstat 
  where statistic# = ( select statistic# from v$statname where name = 'CPU used by this session') 
  and sid != sys_context('USERENV','SID') 
  and sid in ( select sid from v$session where username = 'OGB')
  order by 4
))
where pct not like '00.00%';

