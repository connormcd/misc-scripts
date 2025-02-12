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
@drop t1
@drop t2
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
create table t as
select 
  cast(sysdate+rownum as timestamp) ts, 
  rownum x,
  rownum y
from dual
connect by level <= 1000;
set autotrace traceonly explain
pause
select *
from t
where ts > systimestamp;
set autotrace off
pause
clear screen
create table t1 as
select 
  to_char(rownum) vc,
  rownum x,
  rownum y
from dual
connect by level <= 1000;
pause
set autotrace traceonly explain
pause
select *
from t1
where vc = 12;
set autotrace off
pause
clear screen
select ts, dump(ts) from t
where rownum = 1;
pause
select systimestamp, dump(systimestamp)
from dual;
pause
clear screen
set autotrace traceonly explain
pause
select *
from t
where ts > cast(systimestamp as timestamp);
pause
select *
from t
where ts > localtimestamp;
set autotrace off
