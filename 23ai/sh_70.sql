clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
set timing off
@drop t
set lines 200
create table t 
segment creation immediate
memoptimize for write 
as select empno*1000 empno, ename, job, sal*1000 sal 
from scott.emp;
begin
  for i in 1..1000 loop
    insert /*+ memoptimize_write */  into t values (i, 'emp', 'sales', i);
  end loop;
end;
/
@drop t
set pages 999
set verify off
clear screen
set termout on
set echo off
prompt |
prompt |           
prompt |   
prompt |     __  __ ______ __  __  ____  _____ _______ _____ __  __ _____ ____________ 
prompt |    |  \/  |  ____|  \/  |/ __ \|  __ \__   __|_   _|  \/  |_   _|___  /  ____|
prompt |    | \  / | |__  | \  / | |  | | |__) | | |    | | | \  / | | |    / /| |__   
prompt |    | |\/| |  __| | |\/| | |  | |  ___/  | |    | | | |\/| | | |   / / |  __|  
prompt |    | |  | | |____| |  | | |__| | |      | |   _| |_| |  | |_| |_ / /__| |____ 
prompt |    |_|  |_|______|_|  |_|\____/|_|      |_|  |_____|_|  |_|_____/_____|______|
prompt |                                                                               
prompt |                                                                               
prompt |   
prompt |   
pause
set echo on
clear screen
create table t 
segment creation immediate
memoptimize for write as
select empno*1000 empno, ename, job, sal*1000 sal 
from scott.emp;
pause
set timing on
begin
for i in 1..1000000 loop
    insert into t 
    values (i, 'emp', 'sales', i);
end loop;
commit;
end;
/
pause
set timing off
clear screen
truncate table t;
pause
set timing on
begin
  for i in 1..1000000 loop
    insert /*+ memoptimize_write */  into t values (i, 'emp', 'sales', i);
  end loop;
end;
/
pause
set timing off
clear screen
--
-- BUT THIS ?!?!?!---+
--                   |       
-- begin             |
--   for i in ...    V
--     insert /*+ MEMOPTIMIZE_WRITE */  into t values (i, 'emp', 'sales', i);
--   end loop;
-- end;
-- 
pause
show parameter memoptimize_writes
pause
alter session set memoptimize_writes = on;
pause
set timing off
clear screen
truncate table t;
set timing on
begin
  for i in 1..1000000 loop
    insert into t values (i, 'emp', 'sales', i);
  end loop;
end;
/
set timing off

pause Done

