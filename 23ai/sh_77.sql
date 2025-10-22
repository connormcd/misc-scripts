clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
clear screen
set termout on
set echo off
set serverout on
prompt |   
prompt |    __          ___    _ ______ _____  ______       ___         ___  
prompt |    \ \        / / |  | |  ____|  __ \|  ____|     |__ \       / _ \ 
prompt |     \ \  /\  / /| |__| | |__  | |__) | |__           ) |     | | | |
prompt |      \ \/  \/ / |  __  |  __| |  _  /|  __|         / /      | | | |
prompt |       \  /\  /  | |  | | |____| | \ \| |____       / /_   _  | |_| |
prompt |        \/  \/   |_|  |_|______|_|  \_\______|     |____| (_)  \___/ 
prompt |                                                                     
prompt |                                                                     
pause
clear screen
set echo on
clear screen
select empno, ename, sal
from emp;
pause
clear screen
--
-- Which employees have salary greater than company average?
--
pause
select deptno, empno, ename, sal, avg(sal) over () avg_sal
from emp
order by deptno;
pause
clear screen

select deptno, empno, ename, sal, avg(sal) over () avg_sal
from emp
where sal > avg(sal) over ()
order by deptno

pause
/
pause
select *
from (
  select deptno, empno, ename, sal, avg(sal) over () avg_sal
  from emp
)  
where sal > avg_sal
order by deptno;
pause
clear screen
--
-- Why is this blocked?
--
pause
clear screen
select 
  avg(sal) avg1, 
  avg(case when deptno in (10,20) then sal end) avg2
from emp;
pause
select deptno, empno, ename, sal, avg(sal) over () avg_sal
from emp
where deptno in (10,20)
and   sal > avg(sal) over ()   -- ?????????
order by deptno


pause
clear screen
select deptno, empno, ename, sal, avg(sal) over () avg_sal
from emp
qualify sal > avg(sal) over () 
order by deptno;
pause
select deptno, empno, ename, sal
from emp
qualify sal > avg(sal) over () 
order by deptno;
pause
clear screen
select deptno, empno, ename, sal, avg(sal) over () avg_sal
from emp
qualify sal > avg_sal
order by deptno;
pause

select deptno, empno, ename, sal, avg(sal) over () avg_sal
from emp
where deptno in (10,20)
qualify sal > avg_sal
order by deptno;

pause Done
