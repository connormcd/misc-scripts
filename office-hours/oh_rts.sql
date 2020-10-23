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
conn USER/PASSWORD@db192_pdb1
@drop t
@clean
set echo on
set pagesize 5000
set linesize 200
col column_name format a13 
col low_value format a14
col high_value format a14
col notes format a50
col partition_name format a13
set termout on
clear screen
create table t ( x int, y int, z int );
insert into t values (1,1,1);
commit;
exec dbms_stats.gather_table_stats('','T')
pause
select column_name, low_value, high_value, notes
from   user_tab_col_statistics
where  table_name = 'T'
order by 1,4;
pause
clear screen

insert into t 
select rownum, rownum, rownum
from dual 
connect by level <= 1000;
commit;
pause
clear screen
select num_rows, blocks, notes
from user_tab_statistics
where table_name = 'T';
pause
select column_name, low_value, high_value, notes
from   user_tab_col_statistics
where  table_name = 'T'
order by 1,4;
pause
clear screen
exec dbms_stats.flush_database_monitoring_info;
pause
select column_name, low_value, high_value, notes
from   user_tab_col_statistics
where  table_name = 'T'
order by 1,4;
pause
select num_rows, blocks, notes
from user_tab_statistics
where table_name = 'T';
pause
clear screen
insert into t 
select rownum+2000, rownum+2000, rownum
from dual 
connect by level <= 1000;
commit;
pause
exec dbms_stats.flush_database_monitoring_info;
pause
clear screen
select column_name, low_value, high_value, notes
from   user_tab_col_statistics
where  table_name = 'T'
order by 1,4;

select num_rows, blocks, notes
from user_tab_statistics
where table_name = 'T';
