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
@drop t
set termout on
set echo on
create table t as
select * from scott.emp;
pause
alter table t shrink space

pause
/
pause
alter table t enable row movement;
pause
alter table t shrink space;
pause
clear screen
drop table t purge;
create table t as
select * from scott.emp;
pause
alter table t shrink space check

pause
/
pause
alter table t enable row movement;
pause
alter table t shrink space check

pause
/
pause
alter table t shrink space;



