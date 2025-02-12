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
conn SYS_USER/PASSWORD@MY_PDB
set termout off
col data format a50 wrap
drop view emp_js;
@drop t
set termout on
set echo on
clear screen
set termout on
create or replace json duality view emp_js as
select 
json {
  '_id'   : empno,
  'ename' : ename,
  'sal'   : sal,
  'hiredate' : hiredate,
  'deptno' : deptno
  }
from emp;
pause
set echo off
prompt |
prompt |  "Um....big deal?"
prompt |
pause
set echo on 
clear screen
create or replace json duality view emp_js as
select 
json {
  '_id'   : empno,
  'ename' : ename,
  'sal'   : sal,
  'hiredate' : hiredate,
  'deptno' : deptno
  }
from emp
with (update,insert,delete);
pause
set lines 60
clear screen
desc emp_js
pause
set lines 120
select data  
from emp_js e
where e.data."_id" = 7369;
pause
select json_serialize(data pretty) 
from emp_js e
where e.data."_id" = 7369;
pause
clear screen
update emp
set sal = sal + 99
where empno = 7369;
pause
select json_serialize(data pretty) 
from emp_js e
where e.data."_id" = 7369;
pause
clear screen
insert into emp_js
values (
'{
  "_id" : 8000,
  "ename" : "CONNOR",
  "sal" : 1000,
  "hiredate" : "1980-12-17T00:00:00",
  "deptno" : 20
}');
pause
select * from emp
order by empno;
pause
roll;
pause
clear screen
update emp_js e
set data = 
'{
  "_metadata" :
  {
    "etag" : "DFE10C3EBE1BE0C0071C036A30199975",
    "asof" : "00000000004FFE10"
  },
  "_id" : 7369,
  "ename" : "SMITH",
  "sal" : 500,
  "hiredate" : "1980-12-17T00:00:00",
  "deptno" : 20
}'
where e.data."_id" = 7369;
pause
select * from emp
where empno = 7369;
pause
clear screen
select json_serialize(data pretty) 
from emp_js e
where e.data."_id" = 7369;
pause
--
-- fails because new etag
--
update emp_js e
set data = 
'{
  "_metadata" :
  {
    "etag" : "DFE10C3EBE1BE0C0071C036A30199975",
    "asof" : "00000000004FFE10"
  },
  "_id" : 7369,
  "ename" : "SMITH",
  "sal" : 500,
  "hiredate" : "1980-12-17T00:00:00",
  "deptno" : 20
}'
where e.data."_id" = 7369;
pause
roll;
pause
clear screen
create table t ( 
  c1 int,
  c2 date,
  c3 timestamp with time zone,
  c4 xmltype,
  c5 json,
  c6 clob,
  c7 blob);
pause  
insert into t values 
  (1,sysdate,sysdate,
    xmltype('<tag>qwe</tag>'), 
    '{ "tag" : "value" }', 'my clob', 
    hextoraw('FF1234455667'));
pause
clear screen
select sys_row_etag(c1) "int" from t;
pause
select sys_row_etag(c1,c2) "int/date" from t;
pause
select sys_row_etag(c2,c1) "any_order" from t;
pause
clear screen
select sys_row_etag(c1,c2,c3) "int/date/tstz" from t;
pause
select sys_row_etag(c1,c2,c3,c4) "xmltype" from t;
pause
select sys_row_etag(c5) "json" from t;
pause
clear screen
select sys_row_etag(c1,c2,c3,c5) "int/date/ts/json" from t;
pause
select sys_row_etag(c1,c2,c3,c5,c6,c7) "plus_clob_blob" from t;
pause
clear screen
select t.c4.getclobval() from t t;
pause
select sys_row_etag(t.c4.getclobval()) from t t;
pause
select sys_row_etag(c1||'x') from t;
