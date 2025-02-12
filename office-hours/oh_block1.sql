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
@drop t
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
alter system set max_idle_blocker_time = 1;
pause
create table t as
select 1 x from dual;
pause
delete from t;
--
-- Over to session 2, oh_block1a.sql
--
pause
select * from t;


