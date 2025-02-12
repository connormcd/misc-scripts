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
set termout on
set echo on
create table t( x int, y varchar2(200)) pctfree 0;
pause
insert into t
select rownum, rpad('x',100,'x')
from dual 
connect by level <= 200;
pause
clear screen
select rowid , x from t where x in (1,50,100,200)
order by x;
pause
begin
 for i in 1 .. 200 loop
   update t set y = y||y
   where x = i;
   commit;
 end loop;
end;
/
pause
select rowid , x from t where x in (1,50,100,200)
order by x;
pause
clear screen
drop table t purge;
create table t( x int, y varchar2(200)) pctfree 0;
pause
insert into t
select rownum, rpad('x',100,'x')
from dual 
connect by level <= 200;
pause
alter table t enable row movement;
pause
clear screen
select rowid , x from t where x in (1,50,100,200)
order by x;
pause
begin
 for i in 1 .. 200 loop
   update t set y = y||y
   where x = i;
   commit;
 end loop;
end;
/
pause
select rowid , x from t where x in (1,50,100,200)
order by x;
