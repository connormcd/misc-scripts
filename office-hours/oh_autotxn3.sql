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
clear screen
conn sleepy_tom/sleepy_tom@DB_SERVICE
pause
alter session set txn_priority = medium;
pause
set timing on
pause
rem
rem to session 2 once this starts
rem
update scott.emp
set sal = sal + 10
where empno = 7369;
