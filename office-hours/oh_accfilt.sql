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
conn USER/PASSWORD@MY_PDB
set termout off
clear screen
set timing off
set time off
set pages 999
@drop t
@drop t1
@drop prev_part_tables
@drop prev_tab_partitions
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t as 
select * 
from dba_tables 
where owner in ( 'SYS','SYSTEM','SCOTT','HR','APEX_230100');
exec dbms_stats.gather_table_stats('', 'T')
pause
clear screen
set autotrace traceonly explain
select * 
from   t 
where  owner = 'SYS' 
and    table_name = 'GGG';
pause
clear screen
create index t_ix 
on t (owner, table_name);
pause
select * 
from   t 
where  owner = 'SYS' 
and    table_name = 'GGG';
pause
clear screen
select * 
from   t 
where  owner = 'SYS' 
and    table_name = 'GGG'
and    tablespace_name = 'TS';
pause
clear screen
select * 
from   t 
where  owner = 'SYS' 
and    table_name in ('F','G');
pause
clear screen
select * 
from   t 
where  owner = 'SYS' 
and    table_name in ('F','G','H');
pause
clear screen
select * 
from   t 
where  owner = 'SYS' 
and    table_name in ('F','G','H','I');
pause
clear screen
select * 
from   t 
where  owner = 'SYS' 
and    table_name in ('F','G','H','I','J');
pause
set autotrace off
clear screen
drop table t purge;
create table t as 
select * 
from dba_tables;
pause
create index t_ix 
on t (owner, table_name);
exec dbms_stats.gather_table_stats('', 'T')
pause
set autotrace traceonly explain
clear screen
select * 
from   t 
where  owner = 'SYS' 
and    table_name = 'F';
pause
clear screen
select * 
from   t 
where  owner = 'SYS' 
and    table_name in ('F','G');
pause
clear screen
select  
  /*+ batch_table_access_by_rowid(t)  */  *
from  t
where owner = 'SYS' 
and   table_name in ('F','G');
pause
clear screen
select  
  /*+ num_index_keys(t t_ix 2)  */  *
from  t
where owner = 'SYS' 
and   table_name in ('F','G');
pause
clear screen
select  /*+ num_index_keys(t t_ix 2)  */  *
from t
where owner = 'SYS' 
and table_name in ('F','G','H');
pause
clear screen
select  /*+ num_index_keys(t t_ix 2)  */  *
from t
where owner = 'SYS' 
and table_name in ('F','G','H','I');
pause
clear screen
select  /*+ num_index_keys(t t_ix 2)  */  *
from t
where owner = 'SYS' 
and table_name in ('F','G','H','I','J');
pause
clear screen
select  /*+ num_index_keys(t t_ix 3)  */  *
from t
where owner = 'SYS' 
and table_name in ('F','G','H','I','J');
