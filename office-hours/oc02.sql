REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

conn USER/PASSWORD
alter session set temp_undo_enabled = true;
drop index ix;
@clean
set echo on

create index IX on TX ( object_id ) ;


set timing on
set feedback only
select *
from 
  ( select * 
    from   tx
    order by object_id desc
  )
where rownum <= 10

pause
/
pause
clear screen
set feedback on
set timing off
select * from table(dbms_xplan.display_cursor);
pause
clear screen
set autotrace traceonly explain
select * 
from   tx
order by object_id desc

pause
/
set autotrace off

