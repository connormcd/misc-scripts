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

conn USERNAME/PASSWORD@db21_pdb21a
set termout off
undefine sample_row
col PND_INDEX_NAME format a30
col PND_PARTITION_NAME format a10
@drop t

conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
undefine sample_row
col PND_INDEX_NAME format a30
col PND_PARTITION_NAME format a10
@drop t

set termout on
clear screen
set echo on
select banner from v$version where rownum = 1;
pause
create table t as 
select empno, ename, job
from scott.emp;
pause
create index t_ix on t ( ename)
  indextype is ctxsys.context;
pause
clear screen
insert into t
select empno-1000, ename||'X', job
from scott.emp;
commit;
pause
col PND_ROWID new_value sample_row
pause
select * 
from ctx_user_pending;
pause
select *
from  t
where rowid = '&&sample_row';
pause
set echo off
clear screen
conn USERNAME/PASSWORD@db21_pdb21a
select banner from v$version where rownum = 1;
set echo on
create table t as 
select empno, ename, job
from scott.emp;
pause
create index t_ix on t ( ename)
  indextype is ctxsys.context;
pause
insert into t
select empno-1000, ename||'X', job
from scott.emp;
commit;
pause
select * 
from ctx_user_pending;
pause
clear screen
select * 
from ctx_user_indexes
where idx_name = 'T_IX'
@pr
pause
set echo off
clear screen
conn USERNAME/PASSWORD@SERVICE_NAME
set echo on
select banner from v$version where rownum = 1;
pause
select table_name
from   user_tables
where  table_name like 'DR$T_IX%';
pause

set echo off
clear screen
conn USERNAME/PASSWORD@db21_pdb21a
set echo on
select banner from v$version where rownum = 1;
select table_name
from   user_tables
where  table_name like 'DR$T_IX%';
pause
clear screen
select 
  ( select count(*) from DR$T_IX$N ) n,
  ( select count(*) from DR$T_IX$B ) b, 
  ( select count(*) from DR$T_IX$C ) c, 
  ( select count(*) from DR$T_IX$I ) i, 
  ( select count(*) from DR$T_IX$K ) k, 
  ( select count(*) from DR$T_IX$Q ) q, 
  ( select count(*) from DR$T_IX$U ) u
from dual;
pause
exec ctxsys.ctx_ddl.sync_index('T_IX');
pause
select 
  ( select count(*) from DR$T_IX$N ) n,
  ( select count(*) from DR$T_IX$B ) b, 
  ( select count(*) from DR$T_IX$C ) c, 
  ( select count(*) from DR$T_IX$I ) i, 
  ( select count(*) from DR$T_IX$K ) k, 
  ( select count(*) from DR$T_IX$Q ) q, 
  ( select count(*) from DR$T_IX$U ) u
from dual;
pause
clear screen
insert into t
select empno-2000, ename||'Y', job 
from scott.emp;
commit;
pause
col dml_rid new_value sample_row
select * from DR$T_IX$C;
pause
select *
from  t
where rowid = '&&sample_row';
pause

rem
rem performance changes
rem
pause
set termout off
clear screen
conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
undefine sample_row
col PND_INDEX_NAME format a30
col PND_PARTITION_NAME format a10
@drop t
set termout on
clear screen
set echo on
select banner from v$version where rownum = 1;
create table t as 
select empno, ename, job
from scott.emp;
create index t_ix on t ( ename)
  indextype is ctxsys.context;
pause
clear screen
insert into t
select empno-1000, ename||'X', job
from scott.emp;
pause
select * 
from ctx_user_pending;
pause
set termout off
commit;
clear screen
conn USERNAME/PASSWORD@db21_pdb21a
set termout off
col PND_INDEX_NAME format a30
col PND_PARTITION_NAME format a10
@drop t
clear screen
set echo on
set termout on
select banner from v$version where rownum = 1;
pause
create table t as 
select empno, ename, job
from scott.emp;
create index t_ix on t ( ename)
  indextype is ctxsys.context;
pause
insert into t
select empno-1000, ename||'X', job
from scott.emp;
pause
select * from DR$T_IX$C;
pause
commit;
pause
select * from DR$T_IX$C;
