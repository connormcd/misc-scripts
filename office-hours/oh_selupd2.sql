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
set verify off
clear screen
set echo on
select * from t for update nowait

pause
/
pause

select * from t for update wait 5;
--
-- Back to session 1
--
pause

clear screen

select * from t for update nowait

pause
/
pause

select * from t for update wait 5;
