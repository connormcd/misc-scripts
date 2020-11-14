set termout off
@drop t
@drop ix1
@drop ix2
@clean
set termout on
set echo on
create table t as 
select mod(rownum,8) tag, d.* from dba_objects d,
  ( select 1 from dual connect by level <= 10 );
exec dbms_stats.gather_table_stats('','T',method_opt=>'for all columns size 200');
select num_rows, num_distinct
from   user_tab_columns
where  table_name = 'T'
and    column_name = 'TAG';

create index ix1 on t ( tag );
pause
clear screen
set autotrace traceonly explain
select * from t where tag = 2;
pause
set autotrace traceonly stat
select * from t where tag = 2;
pause

select /*+ index(t) */ * from t where tag = 2;
pause
clear screen
set autotrace off

alter table t
modify partition by hash ( tag ) 
partitions 16
online;
pause
set autotrace traceonly stat
select * from t where tag = 2;
pause
clear screen
drop table t purge;
create table t as 
select mod(rownum,8) tag, d.* from dba_objects d,
  ( select 1 from dual connect by level <= 10 );
create index ix1 on t ( tag );
pause
alter table t add clustering by linear order(tag);
pause
alter table t move online;
pause
exec dbms_stats.gather_table_stats('','T',method_opt=>'for all columns size 200');
pause
clear screen
set autotrace traceonly stat
select /*+ full(t) */* from t where tag = 2;
pause

select /*+ index(t) */ * from t where tag = 2;
pause

set autotrace traceonly explain
select * from t where tag = 2;
