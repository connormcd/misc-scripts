set termout off
conn USERNAME/PASSWORD@db19_pdb1
set termout off
@drop t
@clean
set termout off
set echo on
column table_name format a10 
column num_rows format 9999999
column column_name format a20
column low_value format a15
column high_value format a15
column plan_table_output format a180
col notes format a32
set linesize 250
set tab off
set termout on
select banner from v$version where rownum = 1;

create table t (
  id number(10), 
  num number(10),
  constraint t_pk primary key ( id )
);
pause

insert into t select rownum,rownum from dual connect by rownum<=10000;
exec dbms_stats.gather_table_stats(user,'t')
pause

clear screen

select stale_stats from user_tab_statistics
where  table_name = 'T';
pause

select notes, table_name, num_rows, blocks
from   user_tab_statistics 
where  table_name = 'T';
pause

select notes, table_name, column_name, low_value, high_value, num_distinct
from   user_tab_col_statistics 
where  table_name = 'T';
pause

clear screen

select max(num),count(*) 
from t where id > 9000;
pause
select *
from table(dbms_xplan.display_cursor(format=>'typical'));
pause

clear screen
insert into t select rownum+10000,rownum+10000 from dual connect by rownum<=1000;
commit;
pause
exec dbms_stats.flush_database_monitoring_info;

select stale_stats from user_tab_statistics
where  table_name = 'T';
pause

select notes, table_name, num_rows, blocks
from   user_tab_statistics 
where  table_name = 'T';
pause

select notes, table_name, column_name, low_value, high_value
from   user_tab_col_statistics 
where  table_name = 'T';
pause

set termout off
clear screen
alter system flush shared_pool;
set termout on
select max(num),count(*) 
from t where id > 9000;
pause
select *
from table(dbms_xplan.display_cursor(format=>'typical'));

