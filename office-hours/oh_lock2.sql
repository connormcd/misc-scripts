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
clear screen
set echo on
set termout on
pro *** session 2
pause

update t
set name = 'Connor'
where pk = 11;

pause
pro *** over to session 3
pause

rollback;

pro ** back to session 1
pause


clear screen
update t
set name = 'Connor'
where pk = 11;

pause
pro *** over to session 3
pause
roll;
