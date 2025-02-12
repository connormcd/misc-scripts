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
set timing off
set time off
set pages 999
set lines 200
set termout on
clear screen
set feedback on
set echo on
select count(*)
from t 
where x = 1001;
pause
insert into t
values (1001);
pause
roll;
--
-- back to session 1
-- Enter to exit
pause
exit