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
set feedback on
set echo on
clear screen
set termout on
delete from t where rownum = 1;
--
-- back to session 1
--
pause
commit;
--
-- back to session 1
--
pause
delete from t where rownum = 1;
pause
commit;