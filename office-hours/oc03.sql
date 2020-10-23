REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

exec declare b boolean; begin b := dbms_Result_cache.flush; end;
ALTER SESSION SET result_cache_mode = manual;
@clean
set echo on

set timing on
set feedback only

with first_200 as
( select /*+ result_cache  */ rownum row_seq, f.*
  from 
  ( select * 
    from   tx
    order by owner, object_name desc
  ) f
  where rownum <= 200
)
select * 
from   first_200
where  row_seq <= 10

pause
/

pause
clear screen
with first_200 as
( select /*+ result_cache  */ rownum row_seq, f.*
  from 
  ( select * 
    from   tx
    order by owner, object_name desc
  ) f
  where rownum <= 200
)
select * 
from   first_200
where  row_seq between 11 and 20

pause
/
pause
set lines 200
clear screen
set feedback on
set timing off
select * from table(dbms_xplan.display_cursor(format=>'BASIC +ROWS +COST'));

pause
clear screen

set feedback only
set timing on
with first_200 as
( select /*+ result_cache  */ rownum row_seq, f.*
  from 
  ( select * 
    from   tx
    order by owner, object_name desc
  ) f
  where rownum <= 200
)
select * 
from   first_200
where  row_seq between 21 and 30

pause
/

set timing off
