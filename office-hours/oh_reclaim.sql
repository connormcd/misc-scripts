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
conn USER/PASSWORD@MY_DB
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

select round(32300/29800,2) est_overhead from dual;
pause
clear screen
select num_rows*avg_row_len/8192*100/(100-pct_free)*1.08 est_blocks
from user_tables
where table_name = 'T';
pause

delete from t
where mod(object_id,3) = 0;
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
pause
set echo off
pro
pro But is it worth it?
pro
pro 1) More activity?
pro
pause
set echo on
clear screen
drop table t purge;
create table t as 
select d.* from dba_objects d,
 ( select 1 from dual connect by level <= 20 );

select num_rows, avg_row_len,  blocks, empty_blocks
from user_tables
where table_name = 'T';
pause
clear screen
delete from t
where mod(object_id,3) = 0;
commit;
pause
insert into t
select d.* from dba_objects d,
 ( select 1 from dual connect by level <= 20 )
where rownum <= 554000;
commit;
pause
clear screen
select num_rows, avg_row_len,  blocks, empty_blocks
from user_tables
where table_name = 'T';
pause
exec dbms_stats.gather_table_stats('','T')
pause
select num_rows, avg_row_len,  blocks, empty_blocks
from user_tables
where table_name = 'T';
set echo off
pro
pro But is it worth it?
pro
pro 2) Type of access ?
pro
pause
set echo on
clear screen
drop table t purge;
create table t as 
select d.* from dba_objects d,
 ( select 1 from dual connect by level <= 20 );
create index t_ix on t ( owner );
delete from t
where mod(object_id,3) = 0;
commit;
pause
clear screen
set autotrace on stat
select max(created) from t;
pause
clear screen
select count(*), max(object_id) from t where  owner = 'SYS';
pause
clear screen
select count(*), max(object_id) from t where  owner = 'SYSTEM';
set autotrace off
pause
set echo off
clear screen
pro Full Scan        = ~34,000
pro Large Range Scan = ~26,500
pro Small Range Scan = ~500
pro
pro
set echo on
alter table t move;
alter index t_ix rebuild;
pause
set autotrace traceonly stat
select max(created) from t;
pause
select count(*), max(object_id) from t where  owner = 'SYS';
pause
select count(*), max(object_id) from t where  owner = 'SYSTEM';
set autotrace off



