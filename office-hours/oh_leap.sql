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
@drop sales
@drop date_map
create table sales ( 
  txn_date date,
  amount number(20,2) );

insert into sales values (date '2023-01-13',  48312.26); 
insert into sales values (date '2022-01-13',  56459.47); 

insert into sales values (date '2022-04-07',  44358.32); 
insert into sales values (date '2023-04-07',  2632.06); 
insert into sales values (date '2024-03-29',  3107.55); 
set timing off
set time off
set pages 999
set lines 200
set termout on
clear screen
set feedback on
set echo on
variable str varchar2(14)
exec :str := '13/JAN/2023';
pause
select sum(amount)
from   sales
where  txn_date = to_date(:str);
pause
select txn_date, sum(amount)
from   sales
where  txn_date in (to_date(:str),to_date(:str)-365)
group by txn_date
order by 1;
pause
clear screen
exec :str := '13/JAN/2024';
select
  to_date(:str) ty,
  to_date(:str)-365 ly
from dual;
pause
exec :str := '13/JAN/2025';
select
  to_date(:str) ty,
  to_date(:str)-365 ly
from dual;
pause
clear screen
exec :str := '13/JAN/2025';
select
  to_date(:str) ty,
  add_months(to_date(:str),-12) ly
from dual;
pause
exec :str := '28/FEB/2025';
select
  to_date(:str) ty,
  add_months(to_date(:str),-12) ly
from dual;
pause
clear screen
exec :str := '28/FEB/2023';
select
  to_date(:str) ty,
  to_date(:str) - numtoyminterval (1,'year') ly
from dual;
pause
exec :str := '29/FEB/2024';
select
  to_date(:str) ty,
  to_date(:str) - numtoyminterval (1,'year') ly
from dual;
pause
clear screen
exec :str := '28/FEB/2025';
select
    to_date(:str) ty,
    case when
        substr(:str,1,6) = '28/FEB' and
        to_char(to_date(to_char(
          add_months(to_date(:str),-12),'YYYY')
            ||'1231','yyyymmdd'),'ddd') = 366
    then
      add_months(to_date(:str),-12)-1
    else
      add_months(to_date(:str),-12)
    end ly
from dual;
pause
clear screen
--
-- Why NONE of these will work
--
pause
exec :str := '07/APR/2023';
select txn_date, sum(amount)
from   sales
where  txn_date in (to_date(:str),to_date(:str)-365)
group by txn_date
order by 1;
pause
clear screen
create table date_map
  (  current_date   date primary key,
     last_year      date,
     why            varchar2(100)
 );
pause
insert into date_map
values ('01/JAN/24','01/JAN/23','New Years Day');
pause
insert into date_map
values ('02/JAN/24','03/JAN/23','Tuesday');
pause
insert into date_map
values ('03/JAN/24','04/JAN/23','Wednesday');
pause
insert into date_map
values ('04/JAN/24','05/JAN/23','Thursday');
pause
insert into date_map
values ('29/FEB/24','02/MAR/23','Closest Thursday');
pause
insert into date_map
values ('29/MAR/24','07/APR/23','Good Friday');
pause
clear screen
exec :str := '29/MAR/24';
select s.txn_date, sum(s.amount)
from   sales s,
       date_map d
where  s.txn_date in (d.current_date, d.last_year)
and   d.current_date = to_date(:str)
group by s.txn_date
order by 1;

