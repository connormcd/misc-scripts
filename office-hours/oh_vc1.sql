REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@clean
set termout off
set pages 200
drop table t purge;
clear screen
set echo on
set termout on
create table t 
as select rownum c1, rownum c2, rownum c3
from dual
connect by level <= 100;
pause
create or replace
function VIRT_COL(c number)  return number deterministic is
begin
  dbms_session.sleep(0.1);
  return c;
end;
/
pause

alter table t add slowcol number generated always as ( VIRT_COL(c1) );
pause
clear screen
set arraysize 10
set timing on
select * from t;
pause
clear screen
select c1,c2,c3 from t

pause
/

pause
clear screen
select c1,c2,c3 
from 
( select * from t )

pause
/

select c1,c2,c3 
from 
( select * from t order by c2)

pause
/

alter table t modify slowcol not null;
pause

select c1,c2,c3 
from 
( select * from t where slowcol is not null)

pause
/
set timing off
