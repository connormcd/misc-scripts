REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
conn USER/PASSWORD@MY_PDB
set termout off
BEGIN
  DBMS_STATS.set_global_prefs (
    pname   => 'GLOBAL_TEMP_TABLE_STATS',
    pvalue  => 'SHARED');
END;
/
@drop t
@clean
set termout on

set echo on
--
-- 11g behaviour
--
create global temporary table t ( x int, y int )
on commit preserve rows;
pause
insert into t
select rownum, rownum
from dual
connect by level <= 10000;
pause
exec dbms_stats.gather_table_stats('','T');
pause
clear screen
set autotrace traceonly explain
select * from t;
set autotrace off
pause

set termout off
clear screen
set echo off
set termout on
conn USER/PASSWORD@MY_PDB
set echo on
pause

select * from t;
pause

insert into t
select rownum, rownum
from dual
connect by level <= 50;
commit;
pause

clear screen
set autotrace traceonly explain
select * from t;
set autotrace off
pause

set termout off
conn USER/PASSWORD@MY_PDB
set termout off
set echo off
clear screen
@drop t
set termout on
set echo on
--
-- 12c default behaviour
--
BEGIN
  DBMS_STATS.set_global_prefs (
    pname   => 'GLOBAL_TEMP_TABLE_STATS',
    pvalue  => 'SESSION');
END;
/
pause
clear screen
create global temporary table t ( x int, y int )
on commit preserve rows;
pause
insert into t
select rownum, rownum
from dual
connect by level <= 10000;
pause
exec dbms_stats.gather_table_stats('','T');
pause
clear screen
set autotrace traceonly explain
select * from t;
set autotrace off
pause

set termout off
clear screen
set echo off
set termout on
conn USER/PASSWORD@MY_PDB
set echo on
pause

select * from t;
pause

insert into t
select rownum, rownum
from dual
connect by level <= 50;
commit;
pause
exec dbms_stats.gather_table_stats('','T');
pause
clear screen
set autotrace traceonly explain
select * from t;
set autotrace off
