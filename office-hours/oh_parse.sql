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
conn USER/PASSWORD
@drop t
@clean
set echo on
set termout on

create table t ( x int primary key) organization index;
insert into t
select rownum from dual
connect by level <= 10000;
exec dbms_stats.gather_table_stats('','T');
pause
clear screen
set timing on
declare
  v int;
begin
  for i in 1 .. 10000 loop
    select x into v from t where x = i;
  end loop;
end;
.
pause
/
pause
declare
  v int;
begin
  for i in 1 .. 10000 loop
    execute immediate 'select x from t where x = '||i into v;
  end loop;
end;
.
pause
/

pause
set termout off
connect USER/PASSWORD
clear screen
set timing on
set echo on
set termout on
declare
  c int;
begin
 c := dbms_sql.open_cursor;
 for i in 1 .. 100 loop
    dbms_sql.parse(c,
      q'{
      select o.object_name, o.last_ddl_time, sum(s.bytes)
      from   all_objects o,
             dba_segments s
      where  o.owner = s.owner
      and    o.object_name = s.segment_name
      and    o.object_type = 'TABLE'
      and    o.object_id = }'||i||
      q'{
      group by o.object_name, o.last_ddl_time
      }',
      dbms_sql.native );
  end loop;
  dbms_sql.close_cursor(c);
end;
.
pause
/

pause
select s.name, st.value/100
from v$statname s, v$mystat st
where st.STATISTIC# = s.STATISTIC#
and s.name = 'CPU used by this session';


