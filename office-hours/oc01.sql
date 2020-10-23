REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@clean
set termout off
conn USER/PASSWORD@MY_DB
set termout off
alter session set temp_undo_enabled = true;
alter system archive log current;
-- @drop tx
drop index ix;
@drop query_before
@drop query_before2

--create table tx as 
--select d.* from dba_objects d,
-- ( select 1 from dual connect by level <= 130 )
-- where object_id is not null;

-- alter table tx modify object_id not null;

--alter table tx set unused  (APPLICATION,DEFAULT_COLLATION,DUPLICATED,SHARDED,CREATED_APPID,CREATED_VSNID,MODIFIED_APPID,MODIFIED_VSNID);
select /*+ cache(t) */ count(owner) from tx t;
set termout on
@clean
set echo on
desc tx
pause
set lines 80
clear screen
select num_rows, blocks*8192/1024/1024 mb
from user_tables
where table_name = 'TX';
pause
desc V$SQL_WORKAREA_HISTOGRAM
pause
clear screen
create global temporary table QUERY_BEFORE 
on commit preserve rows as
select * from V$SQL_WORKAREA_HISTOGRAM;
pause

set timing on
set feedback only
select *
from 
  ( select * 
    from   tx
    order by object_id desc
  )
where rownum <= 10
/

pause
set timing off
set feedback on

select 
  s.low_optimal_size,
  s.high_optimal_size,
  s.optimal_executions - b.optimal_executions delta_opt, 
  s.onepass_executions - b.onepass_executions delta_one, 
  s.multipasses_executions - b.multipasses_executions delta_multi,
  s.total_executions - b.total_executions delta
from v$sql_workarea_histogram s,
     query_before b
where s.low_optimal_size = b.low_optimal_size
and s.total_executions - b.total_executions > 0 ;
pause

clear screen
create global temporary table QUERY_BEFORE2 
on commit preserve rows as
select * from V$SQL_WORKAREA_HISTOGRAM;
pause

set timing on
declare
  cnt int := 0;
begin
for i in 
  ( select * 
    from   tx
    order by object_id desc
  )
loop
  cnt := cnt + 1;
  exit when cnt = 10;
end loop;
end;
/

pause
select 
  s.low_optimal_size,
  s.high_optimal_size,
  s.optimal_executions - b.optimal_executions delta_opt, 
  s.onepass_executions - b.onepass_executions delta_one, 
  s.multipasses_executions - b.multipasses_executions delta_multi,
  s.total_executions - b.total_executions delta
from v$sql_workarea_histogram s,
     query_before2 b
where s.low_optimal_size = b.low_optimal_size
and s.total_executions - b.total_executions > 0 ;

set echo off
set timing off
