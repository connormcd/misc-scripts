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
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t ( id int, bigcol long );
pause
insert into t 
values (1, 'somedata');
commit;
pause
select * 
from t;
pause
clear screen
create table t1 
as select * from t;
pause
create table t1 ( id int, bigcol long );
pause
insert into t1
select * from t;
pause
insert into t1
select id, bigcol from t;
pause
clear screen
alter table t add bigcol2 long;
pause
alter table t modify bigcol clob;
pause
select * from t;
pause
drop table t1 purge;
create table t1 
as select * from t;
pause
set lines 60
clear screen
desc dba_views
pause
clear screen
drop table t purge;
create table t (
  owner         varchar2(128),
  view_name     varchar2(128),
  text_length   number, 
  text          long
);
pause
create index t_ix1 on t ( view_name );
create index t_ix2 on t ( text_length);
pause
set lines 200
clear screen
insert into t
select 
  owner,
  view_name,
  text_length,
  text
from dba_views;
pause
copy from SYSTEM_USER/PASSWORD@DB_SERVICE -
insert t (owner,view_name,text_length,text) -
using select owner,view_name,text_length,text -
from dba_views;
pause
exec dbms_stats.gather_table_stats('','T');
pause
clear screen
set autotrace traceonly explain
pause
select *
from t
where view_name like 'ABC%'
or text_length > 100000;
set autotrace off
pause
clear screen
alter table t modify text clob;
pause
set autotrace traceonly explain
pause
select *
from t
where view_name like 'ABC%'
or text_length > 100000;
pause
set autotrace off
clear screen
select index_name, status
from user_indexes
where table_name = 'T';
pause
alter index t_ix1 rebuild;
alter index t_ix2 rebuild;
pause
set autotrace traceonly explain
select *
from t
where view_name like 'ABC%'
or text_length > 100000;
set autotrace off
