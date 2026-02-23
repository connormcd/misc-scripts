clear screen
conn scott/tiger@db23
set echo on
pause
select deptno from dept;
select job,sal from bonus;
select losal,hisal from salgrade;
select sys_context('userenv','sid');
rem
rem back to session 1
rem
