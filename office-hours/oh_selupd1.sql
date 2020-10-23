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
conn USER/PASSWORD@MY_DB
set termout off
set verify off
clear screen
@drop t
set termout on
@clean
set echo on
create table T ( x int primary key, y int);
insert into t values (1,1);
commit;
pause
clear screen
update T set y=y+1;
--
-- Over to session 2
--
pause
rollback;
pause
clear screen
lock table T in exclusive mode;
--
-- Over to session 2
--

