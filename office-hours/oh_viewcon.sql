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
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
drop table mytab;
drop view vw;
set termout on
set echo on
clear screen
create table mytab ( x int );
pause
create or replace 
view vw as 
select * from mytab 
where x > 0
with check option CONSTRAINT CHECK_OP;
pause
select count(*)
from   user_constraints
where constraint_name = 'CHECK_OP';
pause
clear screen
insert into vw values (-1);
pause
alter view vw drop constraint check_op;
pause
insert into vw values (-1)

pause
/
