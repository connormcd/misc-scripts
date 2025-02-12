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
@drop t
set termout off
clear screen
set timing off
set feedback on
set echo on
clear screen
set termout on
create table t (
  pk int,
  x  int,
  c  clob );
pause
insert into t
select rownum, rownum, rpad('x',100)
from dual
connect by level <= 10000;
commit;
pause
alter table t add constraint t_pk primary key (pk);
create index ix on t ( x );
clear screen
alter table t move lob (c) 
store as ( tablespace users);
pause
select index_name, status
from user_indexes
where table_name = 'T';
pause
clear screen
alter table t move -- EVERYTHING
--
-- and here is what do with the LOB
--
lob (c) store as ( tablespace users);
pause
select index_name, status
from user_indexes
where table_name = 'T';
pause
alter index t_pk rebuild;
alter index ix rebuild;
pause
clear screen
alter table t move 
lob (c) store as ( tablespace users)
online;
pause
select index_name, status
from user_indexes
where table_name = 'T';
pause
clear screen
--
-- Definition of ONLINE
--
pause
drop table t purge;
create table t (
  x int primary key,
  c clob );
insert into t
select rownum, rpad('x',32000,'x')
from dual
connect by level <= 3000;
commit;
pause
set timing on
alter table t move lob(c) 
store as ( tablespace users ) online;
pause
set timing off
clear screen
--
-- over to session 2
--
pause
set timing on
alter table t move lob(c) 
store as ( tablespace users ) online;
pause
--
-- ready to flick to session 2
--
pause
alter table t move lob(c) 
store as ( tablespace users ) online;
