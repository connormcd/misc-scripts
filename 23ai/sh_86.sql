clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
@drop time_dimension
@drop fact
exec dbms_random.seed(0);
create table fact (
  order_date date,
  sales      int);
insert into fact
select date '2025-01-01' + dbms_random.value(0,340), mod(rownum,100)
from dual
connect by level <= 50000;
commit;
col department_name format a20
col city format a10
col country_name format a30
set termout on
set echo off
prompt |  
prompt |  
prompt |    _____ _______ _____             ____   ____  _    _ _______    _______ _____ __  __ ______ 
prompt |   |_   _|__   __/ ____|      /\   |  _ \ / __ \| |  | |__   __|  |__   __|_   _|  \/  |  ____|
prompt |     | |    | | | (___       /  \  | |_) | |  | | |  | |  | |        | |    | | | \  / | |__   
prompt |     | |    | |  \___ \     / /\ \ |  _ <| |  | | |  | |  | |        | |    | | | |\/| |  __|  
prompt |    _| |_   | |  ____) |   / ____ \| |_) | |__| | |__| |  | |        | |   _| |_| |  | | |____ 
prompt |   |_____|  |_| |_____/   /_/    \_\____/ \____/ \____/   |_|        |_|  |_____|_|  |_|______|
prompt |                                                                                               
prompt |                                                            
pause
set echo on
clear screen
create table time_dimension (
  real_date        date,
  calendar_month   date,
  calendar_week    number,
  day_of_week      ...
  fiscal_year      ...
  fiscal_week      ...
  retail_week      ...
  etc
  etc
  etc
  etc
)
.
pause
select t.day_of_week,
       sum(sales)
from   fact f,
       time_dimension t
where  f.order_date = t.real_date
group by t.day_of_week
.
select t.fiscal_year,
       sum(sales)
from   fact f,
       time_dimension t
where  f.order_date = t.real_date
group by t.fiscal_year
.
pause
clear screen
select calendar_year(date '2025-03-15', 'yyyy') year;
pause
select
  fiscal_year(date '2025-05-15', date '2025-06-01') may_fy,
  fiscal_year(date '2025-06-15', date '2025-06-01') jun_fy;
pause
clear screen
select
  retail_month(order_date, 'DEFAULT', 'restated') month,
  sum(sales) sales
from fact
group by all
order by 1;
pause
clear screen
select
  retail_month(order_date, 'YYYY-MM', 'restated') month,
  sum(sales) sales
from fact
where retail_day_exists(order_date, 'restated') = true
group by all
order by 1;
pause
clear screen
select
  calendar_quarter_start_date(date '2025-06-15') cqs,
  fiscal_year_end_date(date '2025-06-15', date '2025-06-01') fye,
  retail_month_start_date(date '2025-06-15') rms;
pause
select
  calendar_day_of_week(date '2025-01-01', 'date') dt,
  calendar_day_of_week(date '2025-01-01', 'position') pos;
pause
select
  fiscal_add_months(date '2025-02-01', 1, date '2025-06-05') feb1;
--
-- and many many more ...
--
pause  Done
