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
conn SYSTEM_USER/PASSWORD@pdb21b
set termout off
drop table scott.t purge;
set termout off
clear screen
set timing off
set feedback on
set echo on
clear screen
set termout on
conn SYSTEM_USER/PASSWORD@pdb21b
pause
alter system set max_iops = 0;
pause
create table scott.t pctfree 99
as select rownum x, rpad('x',100) y
from dual
connect by level <= 50000;
create index scott.ix on scott.t ( x );
pause
clear screen
alter system flush buffer_cache;
pause
conn scott/tiger@pdb21b
--
-- back to session 1
--
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
--
-- session 1
--
pause
clear screen
conn SYSTEM_USER/PASSWORD@pdb21b
alter system flush buffer_cache;
conn scott/tiger@pdb21b
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
