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

col  is_bind_sensitive format a18
col  is_bind_aware format a14
col  is_shareable format a14
col sql_text format a42 wrap

alter session set cursor_sharing = exact;
alter session set "_optimizer_adaptive_cursor_sharing" = true;
alter session set "_optim_peek_user_binds" = true;
alter session set optimizer_features_enable='18.1.0';
col max_data format a30 trunc
@drop t1
@clean
alter system flush shared_pool;
col plan_table_output format a100
set termout on
clear screen
set echo on
create table t1 
( pk int,
  data char(100)
);

pause
clear screen
--
-- 500k rows, almost all of them pk=20
--
insert into t1
select 
  case when rownum < 20 then rownum else 20 end, rownum
from dual
connect by level <= 500000;
create index ix1 on t1 ( pk );
exec dbms_stats.gather_table_stats('','T1');
exec dbms_stats.gather_table_stats('','T1',method_opt=>'for columns pk size 200');
pause
clear screen
select histogram 
from user_tab_col_statistics
where   table_name = 'T1'
and column_name = 'PK';
pause
clear screen
select
      endpoint_value,
      endpoint_number -
         nvl(lag(endpoint_number) over ( order by endpoint_number),0) freq
    from user_histograms
    where   table_name = 'T1'
    and column_name = 'PK'
order by 1;
pause
set verify off
set echo on
clear screen
variable v01 number
exec :v01 := 10;

select max(data) max_data,count(*) 
from   t1
where  pk = :v01;
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause

select 
  sql_text,
  is_shareable,
  is_bind_sensitive,
  is_bind_aware
from 
 v$sql
where sql_id = '3zvfk7yc5zznd';
pause
clear screen
exec :v01 := 20;

pause
select max(data) max_data,count(*) 
from   t1
where  pk = :v01;
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause

select max(data) max_data,count(*) 
from   t1
where  pk = :v01;
pause

select 
  sql_text,
  is_shareable,
  is_bind_sensitive,
  is_bind_aware
from 
 v$sql
where sql_id = '3zvfk7yc5zznd';
pause

clear screen
select max(data) max_data,count(*) 
from   t1
where  pk = :v01;
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
pause

clear screen
exec :v01 := 10;

select max(data) max_data,count(*) 
from   t1
where  pk = :v01;
pause
select * from table(dbms_xplan.display_cursor(format=>'-predicate -note'));
