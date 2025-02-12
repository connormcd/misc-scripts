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
conn SYS_USER/PASSWORD@MY_PDB
set termout off
clear screen
set termout on
set echo on
conn ceo/ceo@DB_SERVICE
pause
select *
from scott.emp
where empno = 7369
for update nowait

pause
/
pause
rem
rem back to session 1
rem
pause

clear screen
conn ceo/ceo@DB_SERVICE
pause
alter session set txn_priority = high;
pause
set timing on
pause
update scott.emp
set sal = sal + 10
where empno = 7369;
commit;

