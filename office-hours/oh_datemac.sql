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
set lines 200
set termout on
clear screen
set feedback on
set echo on
--
-- DAY(d)
-- MONTH(d)
-- YEAR(d)
-- DATEPART(y,m,d)
-- DATEDIFF(part,d1,d2)
--
pause
create or replace
function day(d date) return number is
begin
   return to_number(to_char(d,'DD'));
end;
/
pause
create or replace
function month(d date) return number is
begin
   return to_number(to_char(d,'MM'));
end;
/
pause
create or replace
function year(d date) return number is
begin
   return to_number(to_char(d,'YYYY'));
end;
/
pause
clear screen
select day(sysdate) from dual;
pause
select month(sysdate) from dual;
pause
select year(sysdate) from dual;
pause
clear screen
create or replace
function f1udf(p number) return number is
  pragma udf;
begin
  return p+1;
end;
/
pause
create or replace
function f1(p number) return number is
begin
  return p+1;
end;
/
pause
clear screen
set timing on
select max(f1(i))
from ( select level i from dual connect by level <= 1000 ),
     ( select 1       from dual connect by level <= 1000 );
pause
select max(f1udf(i))
from ( select level i from dual connect by level <= 1000 ),
     ( select 1       from dual connect by level <= 1000 );
pause
set timing off
clear screen
create or replace
function day(d date) return number is
  pragma udf;
begin
   return to_number(to_char(d,'DD'));
end;
/
pause
create or replace
function month(d date) return number is
  pragma udf;
begin
   return to_number(to_char(d,'MM'));
end;
/
pause
create or replace
function year(d date) return number is
  pragma udf;
begin
   return to_number(to_char(d,'YYYY'));
end;
/
pause
clear screen
create or replace
function year_nonudf(d date) return number is
begin
   return to_number(to_char(d,'YYYY'));
end;
/
pause
set timing on
select max(year_nonudf(sysdate+i))
from ( select 1 i from dual connect by level <= 1000 ),
     ( select 1 from dual connect by level <= 1000 );
pause
select max(year(sysdate+i))
from ( select 1 i from dual connect by level <= 1000 ),
     ( select 1 from dual connect by level <= 1000 );
pause
set timing off
clear screen
create or replace
function day(d date) return varchar2 sql_macro(scalar) is
begin
   return q'{to_number(to_char(d,'DD'))}';
end;
/
pause
create or replace
function month(d date) return varchar2 sql_macro(scalar) is
begin
   return q'{to_number(to_char(d,'MM'))}';
end;
/
pause
create or replace
function year(d date) return varchar2 sql_macro(scalar) is
begin
   return q'{to_number(to_char(d,'YYYY'))}';
end;
/
pause
clear screen
select day(sysdate) dy from dual;
pause
select month(sysdate) mm from dual;
pause
select year(sysdate) yy from dual;
pause
clear screen
set timing on
select max(year(sysdate+i))
from ( select 1 i from dual connect by level <= 1000 ),
     ( select 1 from dual connect by level <= 1000 );
pause
set timing off
clear screen
create or replace
function datefromparts(y int, m int, d int) return varchar2 sql_macro(scalar) is
begin
   return q'{
     to_date(
       to_char(y,'fm0000')||to_char(m,'fm00')||to_char(d,'fm00'),
       'yyyymmdd'
       )
       }';
end;
/
pause
select datefromparts(2023,1,17) dp from dual;
pause
clear screen
create or replace
function datediff(part varchar2,d2 date, d1 date) return varchar2 sql_macro(scalar) is
begin
   return q'{
  case 
    when rtrim(upper(part),'S') = 'YEAR' then year(d1)-year(d2)
    when rtrim(upper(part),'S') = 'MONTH' then months_between(d1,d2)
    when rtrim(upper(part),'S') = 'DAY' then trunc(d1-d2)
    when rtrim(upper(part),'S') = 'HOUR' then trunc(d1-d2)*24
    when rtrim(upper(part),'S') = 'MINUTE' then trunc(d1-d2)*1440
    when rtrim(upper(part),'S') = 'SECOND' then (d1-d2)*86400
  end
       }';
end;
/
pause
clear screen
select datediff('year',sysdate,sysdate+500) dd from dual;
pause
select datediff('months',sysdate,sysdate+500) dd from dual;
pause
select datediff('days',sysdate,sysdate+500) dd from dual;
select datediff('hour',sysdate,sysdate+500) dd from dual;
select datediff('minutes',sysdate,sysdate+500) dd from dual;
select datediff('second',sysdate,sysdate+500) dd from dual;
pause
clear screen
create or replace function elapsed(
      ts1 in timestamp,
      ts2 in timestamp
    ) return varchar2 sql_macro(scalar) is
begin
  return '
    extract(day from (ts2-ts1))*86400+
    extract(hour from (ts2-ts1))*3600+
    extract(minute from (ts2-ts1))*60+
   extract(second from (ts2-ts1))';
end;
/
pause
select 
  elapsed(
    systimestamp,
    systimestamp+numtodsinterval(123,'MINUTE')) ela
from dual;
pause
drop function day;
drop function month;
drop function year;
drop function datefromparts;
drop function datediff;
