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
var v1 varchar2(10);
exec :v1 := 'test';
select * from t
where  c1 = :v1;
pause
var v1 number
exec :v1 := 123
select * from t
where  c1 = :v1;
pause
var v1 binary_double
exec :v1 := 456;
select * from t
where  c1 = :v1;
pause
clear screen
select child_number, bind_mismatch
from   v$sql_shared_cursor
where  sql_id in (
  select sql_id from v$sql
  where  sql_text like 'select * from t where  c1 = :v1'
);
pause
set echo off
clear screen
prompt |
prompt |  var v1 varchar2(10);
prompt |  var v1 number
prompt |  var v1 binary_double
prompt |
prompt | But how ????
prompt | 

