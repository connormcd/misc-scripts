clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
drop domain amex ;
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |   ____ ____   ___  _   _ ____    ______   __
prompt |  / ___|  _ \ / _ \| | | |  _ \  | __ ) \ / /
prompt | | |  _| |_) | | | | | | | |_) | |  _ \\ V / 
prompt | | |_| |  _ <| |_| | |_| |  __/  | |_) || |  
prompt |  \____|_| \_\\___/ \___/|_|     |____/ |_|  
prompt |                                             
pause
set echo on
clear screen

set echo on
set termout on

clear screen
select deptno, count(*)
from   emp
group by deptno;
pause
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
#pause
group by 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end  -- make sure I remove 'bonus'
/
pause
clear screen
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
group by bonus;
pause
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
group by bonus
having bonus != 5;
pause
clear screen
alter session set group_by_position_enabled = true;
pause
select 
  case 
    when job = 'SALES' then trunc(sal/100)
    when hiredate > date '1981-02-01' then trunc(nvl(comm,300)/100)
    else ceil(sal/80)
  end bonus,
  count(*)
from   emp
group by 1;


pause Done
