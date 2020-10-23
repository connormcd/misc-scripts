REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set echo off
set serverout on format wrapped
set lines 2000
set feedback off
begin dbms_output.put_line('
SQL> select * from my_user.emp
  2  order by job, empno;

     EMPNO ENAME      JOB              MGR HIREDATE         SAL       COMM     DEPTNO
---------- ---------- --------- ---------- --------- ---------- ---------- ----------
      7788 SCOTT      ANALYST         7566 09-DEC-82       3000        100         20
      7902 FORD       ANALYST         7566 03-DEC-81       3000        100         20
      7369 SMITH      CLERK           7902 17-DEC-80        800                    20
      7876 ADAMS      CLERK           7788 12-JAN-83       1100                    20
      7900 JAMES      CLERK           7698 03-DEC-81        950                    30
      7934 MILLER     CLERK           7782 23-JAN-82       1300                    10
      7566 JONES      MANAGER         7839 02-APR-81       2975                    20
      7698 BLAKE      MANAGER         7839 01-MAY-81       2850                    30
      7782 CLARK      MANAGER         7839 09-JUN-81       2450                    10
      7839 KING       PRESIDENT            17-NOV-81       5000                    10
      7499 ALLEN      SALESMAN        7698 20-FEB-81       1600          0         30
      7521 WARD       SALESMAN        7698 22-FEB-81       1250          0         30
      7654 MARTIN     SALESMAN        7698 28-SEP-81       1250          0         30
      7844 TURNER     SALESMAN        7698 08-SEP-81       1500          0         30

14 rows selected.

SQL>');
end;
/
set lines 120
set feedback on