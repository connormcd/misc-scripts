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
clear screen
set timing off
set time off
@drop emp
col ename format a30
create table emp as select * from scott.emp;
set pages 999
set lines 200
set termout on
clear screen
set echo on
select empno
     , lpad(' ', (level-1)*2) || ename as ename
from emp
start with mgr is null
connect by mgr = prior empno
order siblings by empno;
pause
select empno
     , lpad(' ', (level-1)*2) || ename as ename
     , ( select count(*)
         from emp sub
         start with sub.mgr = emp.empno
         connect by sub.mgr = prior sub.empno
       ) reports
from emp
start with mgr is null
connect by mgr = prior empno
order siblings by empno;
pause
select /*+ gather_plan_statistics */
       empno
     , lpad(' ', (level-1)*2) || ename as ename
     , ( select count(*)
         from emp sub
         start with sub.mgr = emp.empno
         connect by sub.mgr = prior sub.empno
       ) reports
from emp
start with mgr is null
connect by mgr = prior empno
order siblings by empno;
pause
select * 
from table(dbms_xplan.display_cursor(null,null,'IOSTATS LAST'));
pause
select emp.empno
     , lpad(' ', (level-1)*2) || emp.ename as ename
     , lat.cnt reports
from emp, 
lateral ( select count(*) cnt
         from emp sub
         start with sub.mgr = emp.empno
         connect by sub.mgr = prior sub.empno ) lat
start with emp.mgr is null
connect by emp.mgr = prior emp.empno
order siblings by emp.empno;
pause
select /*+ gather_plan_statistics */
       emp.empno
     , lpad(' ', (level-1)*2) || emp.ename as ename
     , lat.cnt reports
from emp, 
lateral ( select count(*) cnt
         from emp sub
         start with sub.mgr = emp.empno
         connect by sub.mgr = prior sub.empno ) lat
start with emp.mgr is null
connect by emp.mgr = prior emp.empno
order siblings by emp.empno;
pause
select * 
from table(dbms_xplan.display_cursor(null,null,'IOSTATS LAST'));
pause
clear screen
select lev, empno, ename, rownum rn
from 
(
select empno
     , level lev
     , lpad(' ', (level-1)*2) || ename as ename
from emp
start with mgr is null
connect by mgr = prior empno
order siblings by empno
);
pause
clear screen
--        LEV      EMPNO ENAME                                  RN
-- ---------- ---------- ------------------------------ ----------
--          1       7839 KING                                    1
--      ==> 2       7566   JONES                                 2
--        > 3       7788     SCOTT                               3
--        > 4       7876       ADAMS                             4
--        > 3       7902     FORD                                5
--        > 4       7369       SMITH                             6
--          2       7698   BLAKE                                 7
--          3       7499     ALLEN                               8
--          3       7521     WARD                                9
--          3       7654     MARTIN                             10
--          3       7844     TURNER                             11
--          3       7900     JAMES                              12
--          2       7782   CLARK                                13
--          3       7934     MILLER                             14
-- 
--   a) start at "n"
--   b) go while "lev" > "n"
-- 
pause
clear screen
with raw_data as (
   select lvl, empno, ename, rownum as rn
   from ( select level as lvl, empno, ename
          from emp
          start with mgr is null
          connect by mgr = prior empno
          order siblings by empno  )  )
#pause    
select empno
     , lpad(' ', (lvl-1)*2) || ename as ename
     , reports
from raw_data
match_recognize (
   order by rn
   measures
   --
   pattern (starting_level higher_level*)
   define  higher_level as lvl > starting_level.lvl
)
order by rn

pause
clear screen
with raw_data as (
   select lvl, empno, ename, rownum as rn
   from ( select level as lvl, empno, ename
          from emp
          start with mgr is null
          connect by mgr = prior empno
          order siblings by empno  ) )
select empno
     , lpad(' ', (lvl-1)*2) || ename as ename
     , reports
from raw_data
match_recognize (
   order by rn
   measures
#pause   
      starting_level.rn as rn
    , starting_level.lvl as lvl
    , starting_level.empno as empno
    , starting_level.ename as ename
    , count(higher_level.lvl) as reports
   one row per match
   pattern (starting_level higher_level*)
   define  higher_level as lvl > starting_level.lvl
)
order by rn

pause
/
pause
clear screen
--        LEV      EMPNO ENAME                                  RN
-- ---------- ---------- ------------------------------ ----------
--      ==> 1       7839 KING                                    1
--        > 2       7566   JONES                                 2
--        > 3       7788     SCOTT                               3
--        > 4       7876       ADAMS                             4
--        > 3       7902     FORD                                5
--        > 4       7369       SMITH                             6
--        > 2       7698   BLAKE                                 7
--        > 3       7499     ALLEN                               8
--        > 3       7521     WARD                                9
--        > 3       7654     MARTIN                             10
--        > 3       7844     TURNER                             11
--        > 3       7900     JAMES                              12
--        > 2       7782   CLARK                                13
--        > 3       7934     MILLER                             14
-- 
--   Done!
-- 
pause
clear screen
with raw_data as (
   select lvl, empno, ename, rownum as rn
   from ( select level as lvl, empno, ename
          from emp
          start with mgr is null
          connect by mgr = prior empno
          order siblings by empno  ) )
select empno
     , lpad(' ', (lvl-1)*2) || ename as ename
     , reports
from raw_data
match_recognize (
   order by rn
   measures
      starting_level.rn as rn
    , starting_level.lvl as lvl
    , starting_level.empno as empno
    , starting_level.ename as ename
    , count(higher_level.lvl) as reports
   one row per match
   AFTER MATCH SKIP TO NEXT ROW
   pattern (starting_level higher_level*)
   define  higher_level as lvl > starting_level.lvl
)
order by rn

pause
/
pause
clear screen
with raw_data as (
   select lvl, empno, ename, rownum as rn
   from ( select level as lvl, empno, ename
          from emp
          start with mgr is null
          connect by mgr = prior empno
          order siblings by empno  ) )
select /*+ gather_plan_statistics */
       empno
     , lpad(' ', (lvl-1)*2) || ename as ename
     , reports
from raw_data
match_recognize (
   order by rn
   measures
      starting_level.rn as rn
    , starting_level.lvl as lvl
    , starting_level.empno as empno
    , starting_level.ename as ename
    , count(higher_level.lvl) as reports
   one row per match
   AFTER MATCH SKIP TO NEXT ROW
   pattern (starting_level higher_level*)
   define  higher_level as lvl > starting_level.lvl
)
order by rn;
pause
select * 
from table(dbms_xplan.display_cursor(null,null,'IOSTATS LAST'));
