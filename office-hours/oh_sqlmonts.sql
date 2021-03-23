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
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
@drop t
set termout on
set echo on
clear screen
create table t as
select
  localtimestamp my_ts_col,
  systimestamp my_tz_col,
  d.*
from dba_objects d;
pause
clear screen
alter system flush shared_pool;
pause
declare
  n1 number := 123;
  res int;
begin
  select /*+ monitor */ count(owner)
  into res
  from  t
  where object_id < n1;
end;
/
pause
select sql_id, sql_text
from v$sql
where sql_text like 'SELECT%monitor%OWNER%';
ppause
set pagesize 0 echo on timing off linesize 1000 trimspool on trim on long 2000000 longchunksize 2000000 feedback off
clear screen
select dbms_sql_monitor.report_sql_monitor(sql_id=>'96yhyxfng6td2',type=>'text',report_level=>'ALL') from dual;
pause
@clean
set echo on
alter system flush shared_pool;
declare
  n1 date := sysdate;
  res int;
begin
  select /*+ monitor */ count(owner)
  into res
  from  t
  where created > n1;
end;
/
pause
select sql_id, sql_text
from v$sql
where sql_text like 'SELECT%monitor%OWNER%';
pause
set pagesize 0 echo on timing off linesize 1000 trimspool on trim on long 2000000 longchunksize 2000000 feedback off
clear screen
select dbms_sql_monitor.report_sql_monitor(sql_id=>'9pxc6rf91pzhu',type=>'text',report_level=>'ALL') from dual;
pause
@clean
set echo on
alter system flush shared_pool;
declare
  n1 varchar2(10) := 'XXX';
  res int;
begin
  select /*+ monitor */ count(owner)
  into res
  from  t
  where owner != n1;
end;
/
pause
select sql_id, sql_text
from v$sql
where sql_text like 'SELECT%monitor%OWNER%';
pause
set pagesize 0 echo on timing off linesize 1000 trimspool on trim on long 2000000 longchunksize 2000000 feedback off
clear screen
select dbms_sql_monitor.report_sql_monitor(sql_id=>'2gft55v7h8xda',type=>'text',report_level=>'ALL') from dual;
pause
@clean
set echo on
alter system flush shared_pool;
declare
  n1 timestamp := timestamp '2021-03-18 13:17:48.456';
  res int;
begin
  select /*+ monitor */ count(owner)
  into res
  from  t
  where my_ts_col < n1;
end;
/
pause
select sql_id, sql_text
from v$sql
where sql_text like 'SELECT%monitor%OWNER%';
pause
set pagesize 0 echo on timing off linesize 1000 trimspool on trim on long 2000000 longchunksize 2000000 feedback off
clear screen
select dbms_sql_monitor.report_sql_monitor(sql_id=>'53u5m7367bk63',type=>'text',report_level=>'ALL') from dual;
pause
@clean
pro |
pro | So what is: 787903120E12311B2E0200
pro |
pause
pro |
pro | 22 chars = 11 hex pairs
pro |
set echo on
with str as 
( select '787903120E12311B2E0200' x from dual)
select substr(x,level*2-1,2)
from str
connect by level <= 11;
pause
set echo off
pro |
pro | byte1    = century + 100
pro | byte2    = year + 100
pro | byte3    = month
pro | byte4    = day
pro | byte5    = hour + 1
pro | byte6    = minute + 1
pro | byte7    = second + 1
pro | byte8-11 = nanoseconds 
pro |
pause
set echo on
clear screen
select timestamp '2021-03-18 13:17:48.456' ts from dual;
with str as 
( select '787903120E12311B2E0200' x from dual)
select to_number(substr(x,level*2-1,2),'XX') dec
from str
connect by level <= 7;
pause
with str as 
( select '787903120E12311B2E0200' x from dual)
select to_number(substr(x,15,8),'XXXXXXXX') dec
from str;
pause
clear screen
create or replace
function ts_from_monitor(p_str varchar2) return timestamp is
  n sys.odcinumberlist := sys.odcinumberlist();
  s varchar2(100) := upper(replace(p_str,','));
  ts varchar2(100);
begin
  for i in 1 .. 11
  loop
    n.extend;
    n(i) := to_number(substr(s,i*2-1,2),'XX');
  end loop;
  
  ts := 
    to_char(n(1)-100,'fm00')||
    to_char(n(2)-100,'fm00')||
    to_char(n(3),'fm00')||
    to_char(n(4),'fm00')||'-'||
    to_char(n(5)-1,'fm00')||
    to_char(n(6)-1,'fm00')||
    to_char(n(7)-1,'fm00')||'.'||
    to_char(to_number(substr(s,15,8),'xxxxxxxx'),'fm000000000');

  return to_timestamp(ts,'yyyymmdd--hh24miss.ff');
end;
/
pause
select ts_from_monitor('787903120E12311B2E0200') from dual;
pause
@clean
set echo on
alter system flush shared_pool;
declare
  n1 timestamp with time zone := systimestamp;
  res int;
begin
  select /*+ monitor */ count(owner)
  into res
  from  t
  where my_tz_col = n1;
end;
/
pause
select sql_id, sql_text
from v$sql
where sql_text like 'SELECT%monitor%OWNER%';
pause
set pagesize 0 echo on timing off linesize 1000 trimspool on trim on long 2000000 longchunksize 2000000 feedback off
clear screen
select dbms_sql_monitor.report_sql_monitor(sql_id=>'cr0u31my5n04w',type=>'text',report_level=>'ALL') from dual;
pause
col name format a30
col value_string format a30
@clean
set echo on
select name, value_string 
from v$sql_bind_capture
where sql_id = 'cr0u31my5n04w';
pause
clear screen
select replace(other_xml,'<',chr(10)||'<') xml
from v$sql_plan
where sql_id = 'cr0u31my5n04w'
and other_xml is not null

pause
/
pause
undefine trace_file
col value format a80
clear screen
alter system flush shared_pool;
col value new_value trace_file
select value
from   v$diag_info
where name = 'Default Trace File';
pause
exec dbms_monitor.session_trace_enable(binds=>true)
pause
declare
  n1 timestamp with time zone := systimestamp;
  res int;
begin
  select /*+ monitor */ count(owner)
  into res
  from  t
  where my_tz_col = n1;
end;
/
disc
pause
host notepad &&trace_file
pause
set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
clear screen
set termout on
set echo on
