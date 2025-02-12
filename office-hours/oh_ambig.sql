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
@drop t
set timing off
set time off
set pages 999
set lines 200
set termout on
set serverout on
clear screen
set feedback on
set echo on
create table t ( x int , y int , z int);
pause
insert into t (x,y,z)
select 1,10,10 from dual
union all
select 1,98,99 from dual;
pause
insert into t (x,y,z)
with data as 
(
  select 1,10,10 from dual
  union all
  select 1,98,99 from dual
)
select * from data;
pause
clear screen
--
-- maybe its the WITH?
--
insert into t (x,y,z)
select * 
from (
  select 1,10,10 from dual
  union all
  select 1,98,99 from dual
);
pause
--
-- maybe its the INSERT?
--
select * 
from (
  select 1,10,10 from dual
  union all
  select 1,98,99 from dual
);
pause
clear screen
--
-- maybe its the UNION ALL
--
select * 
from (
  select 1,10,10 from dual
);
pause
select * 
from (
  select 1,10,20 from dual
);
pause
clear screen
variable tgt clob
declare
  src clob := 
    'select * 
    from (
      select 1,10,10 from dual
    )';
begin
  dbms_utility.expand_sql_text(src,:tgt);
end;
/
pause
variable tgt clob
declare
  src clob := 
    'select * 
    from (
      select 1,10,20 from dual
    )';
begin
  dbms_utility.expand_sql_text(src,:tgt);
end;
/
print tgt
pause
clear screen
select * 
from (
  select 1 c1,10 c2,10 c3 from dual
);
pause
insert into t (x,y,z)
with data as 
(
  select 1 c1,10 c2,10 c3 from dual
  union all
  select 1,98,99 from dual
)
select * from data;
