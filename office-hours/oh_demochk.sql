REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set echo on
clear screen
show user
select table_name, num_rows from user_tables;
pause
select count(*) from emp;
pause
select text from user_source;
pause
exit