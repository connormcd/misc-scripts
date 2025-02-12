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
conn USER/PASSWORD@MY_PDB
set termout off
@drop t
clear screen
set echo on
set termout on
create table t as 
select d.* from dba_objects d,
 ( select 1 from dual connect by level <= 20 );
pause
clear screen
select num_rows, avg_row_len,  blocks, empty_blocks
from user_tables
where table_name = 'T';
pause

select num_rows*avg_row_len/8192*100/(100-pct_free) est_blocks
from user_tables
where table_name = 'T';
pause

select round(36100/33300,2) est_overhead from dual;
pause
clear screen
select num_rows*avg_row_len/8192*100/(100-pct_free)*1.08 est_blocks
from user_tables
where table_name = 'T';
pause

delete from t
where mod(object_id,3) = 0;
pause
clear screen
exec dbms_stats.gather_table_stats('','T')
pause

select blocks, num_rows*avg_row_len/8192*100/(100-pct_free)*1.08 est_blocks
from user_tables
where table_name = 'T';
pause

alter table t move;
pause

exec dbms_stats.gather_table_stats('','T')
pause

select num_rows, avg_row_len,  blocks, empty_blocks
from user_tables
where table_name = 'T';
