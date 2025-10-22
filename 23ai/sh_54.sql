clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop t
@drop returns_some_numbers
@drop return_a_val
@drop return_a_slow_val
alter session set statistics_level = all;
exec dbms_stats.set_global_plsql_prefs('dynamic_stats','OFF')
alter system flush shared_pool;
set termout on
set echo off
prompt |
prompt |                   
prompt |   
prompt |   
prompt |   
prompt |     _______     ___   _          __  __ _____ _____     _____ _______    _______ _____ 
prompt |    |  __ \ \   / / \ | |   /\   |  \/  |_   _/ ____|   / ____|__   __|/\|__   __/ ____|
prompt |    | |  | \ \_/ /|  \| |  /  \  | \  / | | || |       | (___    | |  /  \  | | | (___  
prompt |    | |  | |\   / | . ` | / /\ \ | |\/| | | || |        \___ \   | | / /\ \ | |  \___ \ 
prompt |    | |__| | | |  | |\  |/ ____ \| |  | |_| || |____    ____) |  | |/ ____ \| |  ____) |
prompt |    |_____/  |_|  |_| \_/_/    \_\_|  |_|_____\_____|  |_____/   |_/_/    \_\_| |_____/ 
prompt |                                                                                        
prompt |                                                                                        
prompt |                                                          
prompt |   
pause
set echo on
clear screen
set termout on
set echo on
create or replace
function returns_some_numbers return sys.odcinumberlist is
begin
  return sys.odcinumberlist(1,2,3,4);
end;
/
pause
select *
from table(returns_some_numbers);
pause
clear screen
set autotrace traceonly explain
pause
select *
from table(returns_some_numbers);
set autotrace off
pause
clear screen
create table t as select * from dba_objects where 1=0;
pause
insert into t select * from dba_objects;
pause
create index ix on t ( object_id );
pause
create or replace
function return_a_val(p_num int) return number is
begin
  return p_num;
end;
/
pause
clear screen
set autotrace traceonly explain
select count(*)
from t
where object_id > return_a_val(100) 
  or object_name like 'Z%';
set autotrace off
pause
clear screen
select count(*)
from t
where object_id > return_a_val(100) 
  or object_name like 'Z%';
pause
clear screen
alter system flush shared_pool;
pause
exec dbms_stats.set_global_plsql_prefs('dynamic_stats','ON')
pause
select dbms_stats.get_plsql_prefs('dynamic_stats') ;
pause
clear screen
select *
from table(returns_some_numbers);
pause
set autotrace traceonly explain
pause
select *
from table(returns_some_numbers);
set autotrace off
pause
set autotrace traceonly explain
clear screen
select count(*)
from t
where object_id > return_a_val(100) 
  or object_name like 'Z%'

pause
/
set autotrace off
pause
alter system flush shared_pool;
clear screen
create or replace
function return_a_slow_val(p_num int) return number is
  x number := 10;
begin
  for i in 1 .. 10000 loop
    x := x + 1;
    x := sqrt(x);
  end loop;
  return p_num;
end;
/
pause
set autotrace traceonly explain
select count(*)
from t
where object_id > return_a_slow_val(99) 
  or object_name like 'j%';
set autotrace off
pause
clear screen
exec dbms_stats.set_plsql_prefs(user,'','RETURN_A_SLOW_VAL','dynamic_stats','OFF')
exec dbms_stats.set_plsql_prefs(user,'','RETURN_A_VAL','dynamic_stats','ON')
pause
select object_name,
       dynamic_sampling_on, 
       dynamic_sampling_off,
       dynamic_sampling_choose
from   user_procedures
where  object_name like 'RETURN%';

pause Done
