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
set feedback on
set echo on
set termout on
create table t 
as select rownum c1, rownum c2, rownum c3
from dual
connect by level <= 5000;
pause

alter table t add slowcol number generated always as
 ( 
 sqrt(1+power(sqrt(power(sqrt(power(sqrt(power(sqrt(power(sqrt(1+power(sqrt(
       power(sqrt(power(sqrt(power(sqrt(1+power(
           sqrt(power(sqrt(power(sqrt(power(c3,2)),2)),2)),2)),2)),2)),2)),2)),2)),2)),2)),2)),2))
 );
pause

set timing on
select max(slowcol) from t;
pause

clear screen
set feedback only
set arraysize 500
pause
select * from t order by slowcol;
pause
select * from t order by c3;
pause
clear screen
declare
  x number;
begin
  for c3 in 1 .. 5000
  loop
    x := sqrt(1+power(sqrt(power(sqrt(power(sqrt(power(sqrt(power(sqrt(1+power(sqrt(
           power(sqrt(power(sqrt(power(sqrt(1+power(
             sqrt(power(sqrt(power(sqrt(power(c3,2)),2)),2)),2)),2)),2)),2)),2)),2)),2)),2)),2)),2));
  end loop;
end;
.

pause
/
pause
select slowcol from t;
set feedback on
set timing off



