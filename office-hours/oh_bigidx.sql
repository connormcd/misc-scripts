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
set termout off
@clean
conn USER/PASSWORD@MY_PDB
set termout off
clear screen
set timing off
set time off
set pages 999
@drop t
@drop t1
set lines 200
set termout on
set timing off
-- @drop bigidx
-- drop tablespace slow_ts including contents and datafiles;
col pct format a12
col event format a54
set timing off
-- create tablespace slow_ts
-- datafile 'V:\slow_oradata\db21\slow_ts.dbf' size 10m
-- autoextend on next 4m;

-- create table bigidx tablespace largets nologging as
-- select d.* from dba_objects d,
--  ( select 1 from dual connect by level <= 100 );

drop index bigidx_ix;
drop index bigidx_text;
alter database datafile 'V:\slow_oradata\db21\slow_ts.dbf' resize 10m;
set feedback on
set echo on
clear screen
select blocks, num_rows
from   user_tables
where  table_name = 'BIGIDX';
pause
explain plan for
create index bigidx_ix 
on bigidx ( owner, object_name, object_id, object_type );
pause
select * 
from dbms_xplan.display();
pause
set echo off
clear screen
conn USER/PASSWORD@MY_PDB
set echo on
clear screen
set timing on
create index bigidx_ix 
on bigidx ( owner, object_name, object_id, object_type );
set timing off
pause
select 
   event
  ,total_waits
  ,secs
  ,rpad(to_char(100 * 
     ratio_to_report(secs) over (), 'FM00.00') || '%',8)  pct
from (
  select event
  ,total_waits
  ,total_timeouts
  ,time_waited/100 secs
  from v$session_event
  where sid = sys_context('USERENV','SID') 
  and event not like 'SQL*Net message%'
  union all
  select 'CPU', null, null, value/100 
  from v$mystat
  where statistic# = ( 
      select statistic# 
      from v$statname 
      where name = 'CPU used by this session')
  and sid = sys_context('USERENV','SID')
)
order by 4;
pause
drop index bigidx_ix;
set echo off
clear screen
conn USER/PASSWORD@MY_PDB
set echo on
clear screen
set timing on
create index bigidx_ix 
on bigidx ( owner, object_name, object_id, object_type )
tablespace slow_ts;
set timing off
pause
select 
   event
  ,total_waits
  ,secs
  ,rpad(to_char(100 * 
     ratio_to_report(secs) over (), 'FM00.00') || '%',8)  pct
from (
  select event
  ,total_waits
  ,total_timeouts
  ,time_waited/100 secs
  from v$session_event
  where sid = sys_context('USERENV','SID') 
  and event not like 'SQL*Net message%'
  union all
  select 'CPU', null, null, value/100 
  from v$mystat
  where statistic# = ( 
      select statistic# 
      from v$statname 
      where name = 'CPU used by this session')
  and sid = sys_context('USERENV','SID')
)
order by 4;
pause
set echo off
clear screen
alter session set sql_trace = true;
alter session set sql_trace = false;
clear screen
set echo on
create index bigidx_text
on bigidx ( object_name )
indextype is ctxsys.context

pause
select 'tail -f '||value cmd
from v$diag_info
where name = 'Default Trace File';
pause
exec ctx_output.start_log('index_create');
pause
create index bigidx_text
on bigidx ( object_name )
indextype is ctxsys.context;
exec ctx_output.ctx_output.end_log;



