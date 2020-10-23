REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set echo on
clear screen
desc scott.emp
select index_name from dba_indexes
where table_name = 'EMP'
and owner = 'SCOTT';
pause
clear screen
select * from scott.emp where empno = 10;
pause
select * from dbms_xplan.display_cursor();
pause

clear screen
select /*+ go_faster */ * from scott.emp where empno = 10;
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause


clear screen
select /*+ use_hash */ * from scott.emp where empno = 10;
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ full(emp) */ * from scott.emp where empno = 10;
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ full(scott.emp) */ * from scott.emp where empno = 10;
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ index(emp) */ * from scott.emp where empno = 10;
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ index(emp) */ * from scott.emp e where empno = 10;
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ index(emp_pk) */ * from scott.emp e where empno = 10;
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ use_hash(d) */ *
from  scott.emp e,
      scott.dept d
where e.deptno = d.deptno
and   d.dname = 'SALES';
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause


clear screen
select /*+ leading(e) use_hash(d) */ *
from  scott.emp e,
      scott.dept d
where e.deptno = d.deptno
and   d.dname = 'SALES';
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ leading(e) use_hash(d) use_nl(e) */ *
from  scott.emp e,
      scott.dept d
where e.deptno = d.deptno
and   d.dname = 'SALES';
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

clear screen
select /*+ index(@x e) */ * 
from
( select /*+ qb_name(x) full(e) */ * from scott.emp e where empno = 10 );
pause
select * from dbms_xplan.display_cursor(format=>'-PREDICATE +HINT_REPORT');
pause

