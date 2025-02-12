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
drop function "COUNT";
set timing off
set time off
set pages 999
col RESERVED format a10
col RES_TYPE format a10
col RES_ATTR format a10
col RES_SEMI format a10
set lines 200
set termout on
set serverout on
clear screen
set feedback on
set echo on
create or replace 
function count return int is 
begin 
  return 1; 
end;
/
pause
exec dbms_output.put_line(count);
pause
exec dbms_output.put_line(COUNT);
pause
exec dbms_output.put_line("COUNT");
pause
set lines 60
clear screen
desc V$RESERVED_WORDS
pause
select * from V$RESERVED_WORDS
where keyword = 'COUNT'
@pr
pause
clear screen
create or replace 
function "COUNT(1)" return int is 
begin 
  return 1; 
end;
/
pause
SELECT COUNT(1) FROM SCOTT.EMP;
pause
SELECT "COUNT(1)" FROM SCOTT.EMP;
pause
col keyword format a30
set lines 120
clear screen
select * 
from V$RESERVED_WORDS
where reserved = 'Y'
order by 1 desc
fetch first 10 rows only;
pause
create or replace 
function varchar2 return number is
begin
  return 1;
end;
/
pause
clear screen
select * 
from V$RESERVED_WORDS
where res_attr = 'Y'
order by 1 desc
fetch first 10 rows only;
pause
create or replace 
function NESTED_TABLE_ID return int is 
begin 
  return 1; 
end;
/
pause
drop function NESTED_TABLE_ID;
pause
create or replace
type mytype as object (
 NESTED_TABLE_ID int 
);
/
pause
sho err
pause
drop type mytype;
drop function "COUNT";
