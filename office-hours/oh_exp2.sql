REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@clean
set termout off
alter system archive log current;
@drop stores
@drop customers
@drop sales
drop index store_ix ;
drop index cust_ix ;
drop index sales_ix;
drop index sales_ix_cust ;
drop index sales_ix_prod ;
set termout on
@clean
set echo on
create table stores
 ( store_id     int,
   name         varchar2(20),
   address      varchar2(100),
   country      varchar2(20) );
pause
create table customers
 ( cust_id     int,
   name        varchar2(100),
   signup      date,
   creditlimit int,
   vip         varchar2(1),
   store_id    int );
pause
create table sales
 ( sales_id   int,
   cust_id    int,
   tstamp     timestamp,
   amount     number(10,2),
   prod_id    int );
pause
clear screen
insert /*+ APPEND */ into stores
select rownum, 'store'||rownum, 'address'||rownum , 'AUSTRALIA'
from dual
connect by level <= 50;
 
insert /*+ APPEND */ into customers
select rownum, 'cust'||rownum, sysdate-720+mod(rownum,500), dbms_random.value(1,100),
          case when mod(rownum,10)=0 then 'Y' else 'N' end, mod(rownum,50)+1
from dual
connect by level <= 5000;

insert /*+ APPEND */ into sales
select rownum, 1+mod(rownum,5000), sysdate-720+rownum/(1000000/720),  rownum/1000, mod(rownum,100)
from dual
connect by level <= 1000000;
pause
clear screen
create unique index store_ix on stores ( store_id );
create unique index cust_ix on customers ( cust_id );
create unique index sales_ix on sales ( sales_id);
create index sales_ix_cust on sales ( cust_id);
create index sales_ix_prod on sales ( prod_id , amount);
pause
clear screen

set autotrace traceonly explain 

select prod_id, max(amount)
from   stores st,
       customers c,
       sales s
where  s.cust_id = c.cust_id(+)
and    c.store_id = st.store_id
and    s.amount > 10
group by prod_id

pause
/

pause
clear screen
alter table stores    add primary key (store_id );
alter table customers add primary key (cust_id );
alter table sales     add primary key (sales_id );

pause
clear screen
alter table sales     modify cust_id not null;
alter table sales     modify prod_id not null;
alter table sales     modify amount not null;
alter table customers modify store_id not null;

pause
clear screen
alter table customers add constraint cust_fk
  foreign key ( store_id) references stores ( store_id );

alter table sales add constraint sales_fk
  foreign key ( cust_id) references customers ( cust_id );

pause
clear screen

select prod_id, max(amount)
from   stores st,
       customers c,
       sales s
where  s.cust_id = c.cust_id(+)
and    c.store_id = st.store_id
and    s.amount > 10
group by prod_id

pause
/

set autotrace off
