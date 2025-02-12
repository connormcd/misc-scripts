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
col sql_text format a80
alter system flush shared_pool;
set termout on
clear screen
set echo on
alter session set cursor_sharing=force;
pause
SELECT /*FINDME1*/ * FROM EMP WHERE ENAME='KING';
pause
select sql_text
from   v$sql
where  sql_text like 'S%FINDME%';
pause
clear screen
variable v1 number;
exec :v1 := 0;
pause
SELECT /*FINDME2*/ * FROM EMP WHERE EMPNO > :V1;
pause
select sql_text
from   v$sql
where  sql_text like 'S%FINDME%';
pause
clear screen
SELECT /*FINDME3*/ * FROM EMP WHERE EMPNO > :V1 AND ENAME='KING';
pause
select sql_text
from   v$sql
where  sql_text like 'S%FINDME%';
pause
clear screen
declare
  r emp%rowtype;
begin
  SELECT /*+ FINDME4*/ * INTO r FROM EMP WHERE ENAME='KING';
end;
/
pause
select sql_text
from   v$sql
where  sql_text like 'SEL%FINDME4%';
pause
clear screen
declare
  r emp%rowtype;
begin
  execute immediate 
    q'{SELECT /*+ FINDME5*/ * FROM EMP WHERE ENAME='KING'}' 
  into r ;
end;
/
pause
select sql_text
from   v$sql
where  sql_text like 'SEL%FINDME5%';
pause
clear screen
declare
  r emp%rowtype;
  e int := 0;
begin
  execute immediate 
    q'{SELECT /*+ FINDME6*/ * FROM EMP WHERE EMPNO > :b1 AND ENAME='KING'}' 
  into r using e;
end;
/
pause
select sql_text
from   v$sql
where  sql_text like 'SEL%FINDME6%';
pause
clear screen
declare
  l_cur     pls_integer;
  l_col     number;
  l_exec    number;
  l_sql     varchar2(100) := 
    q'{SELECT /*+ FINDME7*/ * FROM EMP WHERE EMPNO > :b1 AND ENAME='KING'}';
begin
  l_cur := dbms_sql.open_cursor;
  dbms_sql.parse(l_cur,l_sql,dbms_sql.native);
  dbms_sql.bind_variable(l_cur,'b1',0);
  l_exec := dbms_sql.execute(l_cur);
  while dbms_sql.fetch_rows(l_cur) > 0 loop
    null;
  end loop;
  dbms_sql.close_cursor(l_cur);
end;
/
pause
select sql_text
from   v$sql
where  sql_text like 'SEL%FINDME7%';

