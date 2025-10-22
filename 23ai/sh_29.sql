clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
set termout on
set echo off
prompt |   
prompt |   
prompt |   
prompt |     _____  ______  _____ _    _ _   _______      _____          _____ _    _ ______ 
prompt |    |  __ \|  ____|/ ____| |  | | | |__   __|    / ____|   /\   / ____| |  | |  ____|
prompt |    | |__) | |__  | (___ | |  | | |    | |      | |       /  \ | |    | |__| | |__   
prompt |    |  _  /|  __|  \___ \| |  | | |    | |      | |      / /\ \| |    |  __  |  __|  
prompt |    | | \ \| |____ ____) | |__| | |____| |      | |____ / ____ \ |____| |  | | |____ 
prompt |    |_|  \_\______|_____/ \____/|______|_|       \_____/_/    \_\_____|_|  |_|______|
prompt |                                                                                     
prompt |                                                                                     
prompt |   
pause
set echo on
clear screen
desc mega_emp
pause
set timing on
select deptno, count(*) 
from mega_emp
group by deptno;
pause
clear screen
select /*+ result_cache */ deptno, count(*) 
from mega_emp
group by deptno;
pause
select /*+ result_cache */ deptno, count(*) 
from mega_emp
group by deptno;
pause
clear screen
set autotrace traceonly explain
select /*+ result_cache */ deptno, count(*) 
from mega_emp
group by deptno;
set autotrace off
pause
set timing off
clear screen
delete from mega_emp
where rownum = 1 ;
commit;
pause
set autotrace traceonly explain
select /*+ result_cache */ deptno, count(*) 
from mega_emp
group by deptno;
set autotrace off
pause
clear screen
set timing on
select /*+ result_cache */ deptno, count(*) 
from mega_emp
group by deptno;
pause
set timing off
set feedback on sql_id
select /*+ result_cache */ deptno, count(*) 
from mega_emp
group by deptno;
pause
set feedback on
select executions, result_cache_executions
from v$sql
where sql_id = '3qd7gah7gbysg';

pause Done
