clear screen
@clean
set termout off
conn dbdemo/dbdemo@db19
set termout off
@drop t
@drop t1
conn dbdemo/dbdemo@db23
set termout off
@drop t
@drop t1
set termout off
clear screen
col full_name format a22
col email_address format a36
set lines 200
set pages 999
set verify off
set termout on
set echo off
prompt |
prompt |                   
prompt |   
prompt |     _____ _   _        _      _____  _____ _______ _____ 
prompt |    |_   _| \ | |      | |    |_   _|/ ____|__   __/ ____|
prompt |      | | |  \| |______| |      | | | (___    | | | (___  
prompt |      | | | . ` |______| |      | |  \___ \   | |  \___ \ 
prompt |     _| |_| |\  |      | |____ _| |_ ____) |  | |  ____) |
prompt |    |_____|_| \_|      |______|_____|_____/   |_| |_____/ 
prompt |                                                          
prompt |                                                          
prompt |   
pause
set echo on
clear screen
conn dbdemo/dbdemo@db19
pause
set lines 200
set pages 999
clear screen
--
-- How it starts :-(
--
pause
select * from company
where rownum <= 10;
pause
select * from organisation;
pause
select call_id, employee_id 
from service_calls
where rownum <= 10;
pause
set lines 120
clear screen
--
-- How many service calls for HR ?
--
pause
select org_id
from organisation
where org_name = 'HR';
pause
select employee_id
from   company
where  org_id = 20
.
pause
/
pause
--
-- select ..
-- from service_calls
-- where employee_id in <that list>
--
pause
clear screen
variable emplist varchar2(32000)
pause
begin
  select listagg(employee_id,',')
  into   :emplist
  from   company
  where  org_id = 20;
end;
/
pause
print emplist
pause
clear screen
variable service_count number
begin
  execute immediate
    'select count(*)
     from   service_calls
     where employee_id in ('||:emplist||')' into :service_count;
end;
/
pause
print service_count
pause
clear screen
--
-- How many service calls for CUSTOMER SERVICE?
--
select org_id
from organisation
where org_name = 'CUSTOMER SERVICE';
pause

variable emplist varchar2(32000)
begin
  select listagg(employee_id,',')
  into   :emplist
  from   company
  where  org_id = 10;
end;
/
pause

print emplist
pause

variable service_count number
begin
  execute immediate
    'select count(*)
     from   service_calls
     where employee_id in ('||:emplist||')' into :service_count;
end;
/
pause
select count(*)
from company
where org_id = 10;
pause
clear screen
conn dbdemo/dbdemo@db23
pause
set echo on
set termout on
set lines 120
set pages 999
col full_name format a22
clear screen
select org_id
from organisation
where org_name = 'CUSTOMER SERVICE';
pause
clear screen
variable emplist varchar2(32000)
begin
  select listagg(employee_id,',')
  into   :emplist
  from   company
  where  org_id = 10;
end;
/
pause
print emplist
pause
variable service_count number
begin
  execute immediate
    'select count(*)
     from   service_calls
     where employee_id in ('||:emplist||')' into :service_count;
end;
/
print service_count
pause

clear screen
create table t ( x primary key ) 
organization index as 
select 1 from dual;
pause
set serverout on
declare
  l_sql clob;
  l_this int := 100000;
  l_prev  int := 1;
  l_cnt   int;
  l_tmp   int;
begin
  loop
    l_sql := 'select count(*) from t where x in (1';
    for i in 2 .. l_this
    loop
      l_sql := l_sql||',1';
    end loop;
    l_sql := l_sql||')';
    begin
      execute immediate l_sql into l_cnt;
      dbms_output.put_line(l_this||' worked');
      l_tmp := l_this;
      l_this := l_this + abs(trunc((l_prev-l_this)/2));
      l_prev := l_tmp;
    exception
      when others then
        dbms_output.put_line(l_this||' failed');
        l_tmp := l_this;
        l_this := l_this - abs(trunc((l_this-l_prev)/2));
        l_prev := l_tmp;
    end;
    exit when l_this = l_prev;
  end loop;
end;
.
pause
/
pause
clear screen
--
-- OMG! But what about all those FILTERs !!!
--
pause
conn dbdemo/dbdemo@db19
create table t1 as 
select d.*, mod(object_id,1000) col 
from dba_objects d, 
  ( select 1 
    from dual 
    connect by level <= 4 );
pause
clear screen
set autotrace traceonly explain
select * 
from t1 
where object_id in ( 1,2,3,4,5,6,7,8);
set autotrace off
pause
clear screen
set autotrace traceonly explain
select * 
from t1 
where col in ( 
01,02,03,04,05,06,07,08,09,10,
11,12,13,14,15,16,17,18,19,20);
pause
clear screen
select * 
from t1 
where col in ( 
01,02,03,04,05,06,07,08,09,10,
11,12,13,14,15,16,17,18,19,20,
21,22,23,24,25,26,27,28,29,30,
31,32,33,34,35,36,37,38,39,40,
41,42,43,44,45,46,47,48,49,50,
51,52,53,54,55,56,57,58,59,60,
61,62,63,64,65,66,67,68,69,70,
71,72,73,74,75,76,77,78,79,80,
81,82,83,84,85,86,87,88,89,90,
91,92,93,94,95,96,97,98,99,100)

pause
/
pause
clear screen
set autotrace traceonly explain
select * 
from t1 
where col in ( 
01,02,03,04,05,06,07,08,09,10,
11,12,13,14,15,16,17,18,19,20,
21,22,23,24,25,26,27,28,29,30,
31,32,33,34,35,36,37,38,39,40,
41,42,43,44,45,46,47,48,49,50,
51,52,53,54,55,56,57,58,59,60,
61,62,63,64,65,66,67,68,69,70,
71,72,73,74,75,76,77,78,79,80,
81,82,83,84,85,86,87,88,89,90,
91,92,93,94,95,96,97,98,99,100,
111,112,113,114,115,116,117,118,119,120,
121,122,123,124,125,126,127,128,129,130,
131,132,133,134,135,136,137,138,139,140,
141,142,143,144,145,146,147,148,149,150,
151,152,153,154,155,156,157,158,159,160,
161,162,163,164,165,166,167,168,169,170,
171,172,173,174,175,176,177,178,179,180
)

pause
/
set autotrace off
pause
clear screen
conn dbdemo/dbdemo@db23
create table t1 as 
select d.*, mod(object_id,1000) col 
from dba_objects d, 
  ( select 1 
    from dual 
    connect by level <= 4 );
pause
clear screen
set autotrace traceonly explain
select * 
from t1 
where object_id in ( 1,2,3,4,5,6,7,8);
set autotrace off
pause
clear screen
set autotrace traceonly explain
select * 
from t1 
where col in ( 
01,02,03,04,05,06,07,08,09,10,
11,12,13,14,15,16,17,18,19,20);
pause
clear screen
select * 
from t1 
where col in ( 
01,02,03,04,05,06,07,08,09,10,
11,12,13,14,15,16,17,18,19,20,
21,22,23,24,25,26,27,28,29,30,
31,32,33,34,35,36,37,38,39,40,
41,42,43,44,45,46,47,48,49,50,
51,52,53,54,55,56,57,58,59,60,
61,62,63,64,65,66,67,68,69,70,
71,72,73,74,75,76,77,78,79,80,
81,82,83,84,85,86,87,88,89,90,
91,92,93,94,95,96,97,98,99,100)

pause
/
pause
clear screen
set autotrace traceonly explain
select * 
from t1 
where col in ( 
01,02,03,04,05,06,07,08,09,10,
11,12,13,14,15,16,17,18,19,20,
21,22,23,24,25,26,27,28,29,30,
31,32,33,34,35,36,37,38,39,40,
41,42,43,44,45,46,47,48,49,50,
51,52,53,54,55,56,57,58,59,60,
61,62,63,64,65,66,67,68,69,70,
71,72,73,74,75,76,77,78,79,80,
81,82,83,84,85,86,87,88,89,90,
91,92,93,94,95,96,97,98,99,100,
111,112,113,114,115,116,117,118,119,120,
121,122,123,124,125,126,127,128,129,130,
131,132,133,134,135,136,137,138,139,140,
141,142,143,144,145,146,147,148,149,150,
151,152,153,154,155,156,157,158,159,160,
161,162,163,164,165,166,167,168,169,170,
171,172,173,174,175,176,177,178,179,180
)

pause
/
set autotrace off

pause Done
