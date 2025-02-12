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
@drop t
alter system flush shared_pool;
col elapsed format 9999.00
col bind_mismatch format a14
col bind_length_upgradeable format a24
clear screen
col name format a20
col datatype_string format a30
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
create table t (
  c1 varchar2(1000)
);
pause
insert into t values ( 'test' );
pause
clear screen
var v varchar2(10);
exec :v := 'test';
pause
select * from t
where  c1 = :v;
pause
var v varchar2(100);
exec :v := 'looooooooooonnnngeeer test';
pause
select * from t
where  c1 = :v;
pause
var v varchar2(1000);
exec :v := rpad ( 'looooooooooonnnngeeer test', 1000, 't' );
pause
select * from t
where  c1 = :v;
pause
clear screen
select child_number, bind_length_upgradeable
from   v$sql_shared_cursor
where  sql_id in (
  select sql_id from v$sql
  where  sql_text like 'select * from t where  c1 = :v'
);
pause
select child_number, name, datatype_string 
from   v$sql_bind_capture
where  sql_id in (
  select sql_id from v$sql
  where  sql_text like 'select * from t where  c1 = :v'
);
pause
clear screen
var v varchar2(32000);
exec :v := rpad ( 'looooooooooonnnngeeer test', 1000, 't' );
pause
select * from t
where  c1 = :v;
pause
select child_number, name, datatype_string 
from   v$sql_bind_capture
where  sql_id in (
  select sql_id from v$sql
  where  sql_text like 'select * from t where  c1 = :v'
);
pause
set echo off
clear screen
host head -30 c:\oracle\sql\oh_bindbig.sql
pause
clear screen
prompt | 
prompt | SQL> select child_number, name, datatype_string
prompt |   2  from   v$sql_bind_capture
prompt |   3  where  sql_id in (
prompt |   4    select sql_id from v$sql
prompt |   5    where  sql_text like 'select * from t where  c1 = :v'
prompt |   6  );
prompt | 
prompt | CHILD_NUMBER NAME                 DATATYPE_STRING
prompt | ------------ -------------------- --------------------------- 

prompt |            6 :V                   VARCHAR2(32767)
prompt |            5 :V                   VARCHAR2(16386)
prompt |            4 :V                   VARCHAR2(8192)
prompt |            3 :V                   VARCHAR2(4000)
prompt |            2 :V                   VARCHAR2(2000)
prompt |            1 :V                   VARCHAR2(128)
prompt |            0 :V                   VARCHAR2(32)
prompt | 
pause
set echo off
clear screen
prompt |
prompt |  var v1 varchar2(10);
prompt |  var v1 varchar2(12);
prompt |  var v1 varchar2(19);
prompt |  var v1 varchar2(23);
prompt |
prompt | But how ????
prompt | 
