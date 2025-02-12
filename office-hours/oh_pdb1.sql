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
conn SYS_USER/PASSWORD as sysdba
set termout off
alter pluggable database pdb21b open;
alter session set container = pdb21b;
alter system set max_iops = 0;
conn SYSTEM_USER/PASSWORD@DB_SERVICE
set termout off
alter system set max_iops = 0;
drop table scott.t purge;
set termout off
clear screen
set timing off
set feedback on
set echo on
clear screen
set termout on
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
alter system set max_iops = 500 scope=memory;
pause
alter system set max_iops = 500 scope=spfile;
pause
select name from v$pdbs;
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
create table scott.t pctfree 99
as select rownum x, rpad('x',100) y
from dual
connect by level <= 50000;
pause
create index scott.ix on scott.t ( x );
pause
clear screen
alter system flush buffer_cache;
pause
conn scott/tiger@DB_SERVICE
pause
set timing on
declare
  rnd int;
  r t%rowtype;
begin
for i in 1 .. 49999 loop
  rnd := dbms_random.value(1,50000);
  select * into r
  from t where x = rnd;
end loop;
end;
/
pause
set timing off
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
alter system set max_iops = 2500;
pause
alter system flush buffer_cache;
pause
clear screen
conn scott/tiger@DB_SERVICE
set timing on
declare
  rnd int;
  r t%rowtype;
begin
for i in 1 .. 49999 loop
  rnd := dbms_random.value(1,50000);
  select * into r
  from t where x = rnd;
end loop;
end;
/
pause
set timing off
--
-- WHY?
--
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE 
alter system set max_iops = 0;
pause
--
-- Get session 2 ready
--
pause
clear screen
conn scott/tiger@DB_SERVICE
pause
set timing on
declare
  rnd int;
  r t%rowtype;
begin
for i in 1 .. 49999*10 loop
  rnd := dbms_random.value(1,50000);
  select * into r
  from t where x = rnd;
end loop;
end;
--
-- start session 2
--
/
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
alter system set max_iops = 1500;
pause
alter system flush buffer_cache;
pause
clear screen
conn scott/tiger@DB_SERVICE
set timing on
declare
  rnd int;
  r t%rowtype;
begin
for i in 1 .. 49999 loop
  rnd := dbms_random.value(1,50000);
  select * into r
  from t where x = rnd;
end loop;
end;
.

--
-- start session 2
--
pause
/
pause
conn SYSTEM_USER/PASSWORD@DB_SERVICE 
alter system set max_iops = 0;
conn SYS_USER/PASSWORD as sysdba
alter pluggable database pdb21b close immediate;
