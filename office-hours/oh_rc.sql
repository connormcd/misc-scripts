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
set autotrace off
clear screen
exec dbms_random.seed(0)
@drop sales
set termout on
set echo on 
create table sales as
with 
  amounts as (
    select /*+ materialize */ trunc(dbms_random.value(1,100),2) amt
    from dual 
    connect by level <= 10000 )
select 
  date '2015-01-01' + rownum/5000 txn_date,
  rownum txn_id,
  mod(rownum,100) cust_id,
  amt
from amounts
     ,(select 1 from dual
       connect by level <= 1000 );
pause

clear screen
set timing on
select sum(amt)
from   sales
where cust_id > 0;
pause

set autotrace on stat
select /*+ result_cache */sum(amt)
from   sales
where  cust_id > 0;
pause

select /*+ result_cache */sum(amt)
from   sales
where  cust_id > 0

pause
/
pause

set echo off
set timing off
clear screen
pro 
pro Sales for current month
pro
set echo on
set timing on
select sum(amt)
from   sales
where  txn_date >= trunc(sysdate,'MM')
and    txn_date < add_months(trunc(sysdate,'MM'),1);
set timing off
pause

set autotrace on stat
select sum(amt)
from   sales
where  txn_date >= trunc(sysdate,'MM')
and    txn_date < add_months(trunc(sysdate,'MM'),1);
pause
clear screen

select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(sysdate,'MM')
and    txn_date < add_months(trunc(sysdate,'MM'),1);
pause

select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(sysdate,'MM')
and    txn_date < add_months(trunc(sysdate,'MM'),1);
pause

clear screen
variable today varchar2(20)
exec :today := to_char(sysdate,'DD-MON-YYYY');
pause

select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1);
pause
select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1);
pause

clear screen
exec dbms_application_info.set_module('0','');

select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    cust_id >= to_number(sys_context('USERENV','MODULE'));
pause
select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    cust_id >= to_number(sys_context('USERENV','MODULE'));
pause

clear screen
exec dbms_application_info.set_module('1000','');

select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    cust_id >= to_number(sys_context('USERENV','MODULE'));
pause

select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    cust_id >= to_number(sys_context('USERENV','MODULE'));
pause

clear screen
select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    uid = 104;
pause
select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    uid = 104;
pause

clear screen

select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    uid = ( select user_id from user_users where username = 'MY_USER' );
pause


select /*+ result_cache */ sum(amt)
from   sales
where  txn_date >= trunc(to_date(:today),'MM')
and    txn_date < add_months(trunc(to_date(:today),'MM'),1)
and    uid = ( select user_id from user_users where username = 'MY_USER' );

