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
conn USER/PASSWORD@MY_PDB
set termout off
clear screen
set timing off
set time off
set pages 999
host ( del "C:\tmp\SALES2018.DMP" "C:\tmp\SALES2018x.DMP" 2>nul )
@drop sales
@drop sales_2018_dmp1
@drop sales_2018_dmp2
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table sales
(cust_name    varchar2(10),
 prod_id      number,
 amount_sold  number ,
 date_of_sale date)
partition by range (date_of_sale)
(
 partition sales_2017 values less than (date '2018-01-01') ,
 partition sales_2018 values less than (date '2019-01-01') ,
 partition sales_2019 values less than (date '2020-01-01')
);
pause
clear screen
insert into sales  values ('cust_b', '1001', '110', date '2018-01-20');
insert into sales  values ('cust_c', '1001', '200', date '2018-01-21');
insert into sales  values ('cust_d', '1000', '108', date '2018-01-22');
insert into sales  values ('cust_e', '1002', '100', date '2018-01-24');
insert into sales  values ('cust_a', '1001', '100', date '2018-01-20');
insert into sales  values ('cust_a', '1001', '100', date '2019-01-20');
commit;
pause
clear screen
alter table sales
add external partition attributes (
  type oracle_datapump
  default directory temp
  access parameters (nologfile)
);
pause
alter table sales
add partition sales_2020 values less than (date '2021-01-01') external
 location ( 'sales2020.dmp');
pause
clear screen
--
-- Gotcha #1
--
pause
alter table sales
add partition sales_2016 values less than (date '2017-01-01') external
 location ( 'sales2016.dmp');
pause
select
 p.partition_name
,p.read_only
,nvl2(e.partition_name,'external','normal') typ
from
  user_tab_partitions p,
  user_xternal_tab_partitions e
where p.table_name = e.table_name(+)
and   p.partition_name = e.partition_name(+)
and   p.table_name = 'SALES'
order by 1;
pause
clear screen
create table sales_2018_dmp1
organization external
( type oracle_datapump 
  default directory temp
  access parameters (nologfile) 
  location ('sales2018.dmp')
)
as select * from sales partition(sales_2018);
pause
alter table sales
exchange partition sales_2018 
with table sales_2018_dmp1;
pause
select
 p.partition_name
,p.read_only
,nvl2(e.partition_name,'external','normal') typ
from
  user_tab_partitions p,
  user_xternal_tab_partitions e
where p.table_name = e.table_name(+)
and   p.partition_name = e.partition_name(+)
and   p.table_name = 'SALES'
order by 1;
pause
clear screen
--
-- Gotcha #2
--
pause
alter table sales
exchange partition sales_2018 
with table sales_2018_dmp1;
pause
select
 p.partition_name
,p.read_only
,nvl2(e.partition_name,'external','normal') typ
from
  user_tab_partitions p,
  user_xternal_tab_partitions e
where p.table_name = e.table_name(+)
and   p.partition_name = e.partition_name(+)
and   p.table_name = 'SALES'
order by 1;
pause
alter table sales modify partition sales_2018 read write;
pause
clear screen
create index idx1 on sales (cust_name)
indexing partial;
pause
create index idx2 on sales (prod_id)
indexing partial local;
pause
--
-- Gotcha #3
--
pause
alter table sales
exchange partition sales_2018 
with table sales_2018_dmp1
update indexes;
pause
clear screen
alter table sales
exchange partition sales_2018 
with table sales_2018_dmp1;
pause
select index_name, status
from   user_indexes
where  index_name = 'IDX1';
pause
select index_name, partition_name, status
from   user_ind_partitions
where  index_name = 'IDX2';
pause
clear screen
drop table sales;
pause
--
-- Gotcha #4
--
create table sales
(pk           number GENERATED AS IDENTITY,
 cust_name    varchar2(10),
 prod_id      number,
 amount_sold  number ,
 date_of_sale date)
partition by range (date_of_sale)
(
 partition sales_2017 values less than (date '2018-01-01') ,
 partition sales_2018 values less than (date '2019-01-01') ,
 partition sales_2019 values less than (date '2020-01-01')
);
pause
insert into sales(cust_name,prod_id,amount_sold,date_of_sale)  
values ('cust_b', '1001', '110', date '2018-01-20');
insert into sales(cust_name,prod_id,amount_sold,date_of_sale)  
values ('cust_c', '1001', '200', date '2018-01-21');
insert into sales(cust_name,prod_id,amount_sold,date_of_sale)  
values ('cust_d', '1000', '108', date '2018-01-22');
insert into sales(cust_name,prod_id,amount_sold,date_of_sale)  
values ('cust_e', '1002', '100', date '2018-01-24');
insert into sales(cust_name,prod_id,amount_sold,date_of_sale)  
values ('cust_a', '1001', '100', date '2018-01-20');
insert into sales(cust_name,prod_id,amount_sold,date_of_sale)  
values ('cust_a', '1001', '100', date '2019-01-20');
commit;
pause
clear screen
alter table sales
add external partition attributes (
  type oracle_datapump
  default directory temp
  access parameters (nologfile)
);
pause
create table sales_2018_dmp2
organization external
( type oracle_datapump 
  default directory temp
  access parameters (nologfile) 
  location ('sales2018x.dmp')
)
as select * from sales partition(sales_2018);
pause
--
-- Gotcha #4 (cont)
--
pause
alter table sales
exchange partition sales_2018 
with table sales_2018_dmp2;
