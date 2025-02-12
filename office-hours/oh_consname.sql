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
undefine trc
set termout off
set timing off
host del /q c:\tmp\trace.prf
@drop t
drop procedure add_or_update;
drop table t purge;
set termout on
clear screen
set echo on
create table t ( 
  x int primary key, 
  y int,
  constraint chk check ( y > 0 )
);
pause
insert into t values (0,0);
pause
clear screen
insert into t
select rownum, rownum
from   dual 
connect by level <= 10;
pause
create or replace
procedure add_or_update(p_x int, p_y int) is
begin
  insert into t
  values (p_x,p_y);
exception
  when dup_val_on_index then
    update t
    set    y = p_y
    where  x = p_x;
end;
/
pause
clear screen
begin
  for p in 1 .. 100 loop
    for q in 1 .. 10 loop
      add_or_update(q,q);
    end loop;
  end loop;
end;
/
pause
select * from t;
pause
clear screen
alter system flush shared_pool;
pause
col value new_value trc
select value
from   v$diag_info
where  name = 'Default Trace File';
pause
alter session set sql_trace = true;
pause
begin
  for p in 1 .. 100 loop
    for q in 1 .. 10 loop
      add_or_update(q,q);
    end loop;
  end loop;
end;
/
disc
pause
host tkprof &&trc c:\tmp\trace.prf
pause
host gawk "/2jfqzrxhrm93b/, /Misses/" c:\tmp\trace.prf
set termout off
conn USER/PASSWORD@MY_PDB
set echo on
set termout on