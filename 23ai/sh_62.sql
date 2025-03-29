clear screen
@clean
set termout off
REM conn dbdemo/dbdemo@db23
set termout off
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
@drop sales
create table sales as
select 
  date '2025-02-27'+dbms_random.value(1,5*86390)/86400 sale_tstamp,
  trunc(dbms_random.value(1,100),2) price,
  mod(rownum,100)+1 cust_id
from dual
connect by level <= 5000;
clear screen
set termout on
set echo off
prompt |  
prompt |  
prompt |    _______ _____ __  __ ______            ____  _    _  _____ _  ________ _______ 
prompt |   |__   __|_   _|  \/  |  ____|          |  _ \| |  | |/ ____| |/ /  ____|__   __|
prompt |      | |    | | | \  / | |__             | |_) | |  | | |    | ' /| |__     | |   
prompt |      | |    | | | |\/| |  __|            |  _ <| |  | | |    |  < |  __|    | |   
prompt |      | |   _| |_| |  | | |____           | |_) | |__| | |____| . \| |____   | |   
prompt |      |_|  |_____|_|  |_|______|          |____/ \____/ \_____|_|\_\______|  |_|   
prompt |                                  ______                                           
prompt |                                 |______|                                          
prompt |  
prompt |  
pause
set echo on
clear screen
select *
from sales
where rownum <= 20;
pause
clear screen
select trunc(sale_tstamp) dte, count(*)
from sales
group by trunc(sale_tstamp)
order by 1;
pause
clear screen
select trunc(sale_tstamp,'YYYY') dte, count(*)
from sales
group by trunc(sale_tstamp,'YYYY')
order by 1;
pause
clear screen
select trunc(sale_tstamp,'HH24') dte, count(*)
from sales
where sale_tstamp >= date '2025-03-01'
and sale_tstamp < date '2025-03-02'
group by trunc(sale_tstamp,'HH24')
order by 1

pause
/
pause
clear screen
--
-- Every 30mins?
--
pause
select trunc(sale_tstamp)+ 1800*trunc(to_number(to_char(sale_tstamp,'SSSSS'))/1800)/86400 halfhr, count(*)
from sales
where sale_tstamp >= date '2025-03-01'
and sale_tstamp < date '2025-03-02'
group by trunc(sale_tstamp)+ 1800*trunc(to_number(to_char(sale_tstamp,'SSSSS'))/1800)/86400
order by 1

pause
/
pause
clear screen
select time_bucket(sale_tstamp, 'P1D', date '2025-02-27',START) bucket, sale_tstamp
from sales
where rownum <= 20;
pause
clear screen
select time_bucket(sale_tstamp, 'P1D', date '2025-02-27',START) bucket, count(*)
from sales
group by bucket
order by 1;
pause
clear screen
select time_bucket(sale_tstamp, 'PT1H', date '2025-02-27',START) bucket, count(*)
from sales
where sale_tstamp >= date '2025-03-01'
and sale_tstamp < date '2025-03-02'
group by bucket
order by 1

pause
/
pause
clear screen
select time_bucket(sale_tstamp, 'PT30M', date '2025-02-27',START) bucket, count(*)
from sales
where sale_tstamp >= date '2025-03-01'
and sale_tstamp < date '2025-03-02'
group by bucket
order by 1

pause
/
pause
clear screen
select time_bucket(sale_tstamp, interval '4' hour, date '2025-02-27',START) bucket, count(*)
from sales
where sale_tstamp >= date '2025-03-01'
and sale_tstamp < date '2025-03-02'
group by bucket
order by 1

pause
/
alter session set nls_date_format = 'DD-MON-RR';
pause Done



