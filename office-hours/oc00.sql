REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
exec dbms_random.seed(0)
set lines 90
@clean
set termout off
@drop tab200k
@drop my_transactions1
@drop my_transactions2

create table tab200k pctfree 0 as 
select rownum seq from dual connect by level <= 200000;

create table my_transactions2
 ( cust_id     int,
   trans_id    int,
   trans_date  date,
   trans_amt   number(10,2),
   trans_comment char(100),
   constraint my_transactions2_pk primary key ( cust_id, trans_id )
 )
organization index;

create table my_transactions1
 ( cust_id       int,
   trans_id      int,
   trans_date    date,
   trans_amt     number(10,2),
   trans_comment char(100),
   constraint my_transactions1_pk primary key ( cust_id, trans_id )
 );
set echo on
set termout on
desc  MY_TRANSACTIONS1
pause
select * from my_transactions1;
pause

insert into my_transactions1
select 
  dbms_random.value(1,500),
  seq,
  date '2010-01-01' + dbms_random.value(1,7*365),
  dbms_random.value(1,100),
  'x'
from tab200k;

commit;
pause
clear screen
set autotrace traceonly stat

select * from my_transactions1
where cust_id = 160

pause
/
pause
/
pause
/
pause
/
pause
/
pause
set autotrace off
clear screen
desc  MY_TRANSACTIONS2
pause
select * from my_transactions2;
pause

insert into my_transactions2
select * from my_transactions1;

pause
clear screen

select count(*) from my_transactions1;
select count(*) from my_transactions2;

pause

select * from my_transactions1
minus
select * from my_transactions2;

select * from my_transactions2
minus
select * from my_transactions1;

pause

select index_name, column_name 
from user_ind_columns
where table_name = 'MY_TRANSACTIONS1';

select index_name, column_name 
from user_ind_columns
where table_name = 'MY_TRANSACTIONS2';

pause
clear screen

set autotrace traceonly stat

select * from my_transactions1
where cust_id = 160

pause
/

set autotrace traceonly stat
select * from my_transactions2
where cust_id = 160

pause
/
pause
/
pause
/

set autotrace off

