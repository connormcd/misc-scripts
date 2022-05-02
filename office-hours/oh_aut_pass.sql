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
host del x:\tmp\scott.emp
clear screen
REM conn admin/PASSWORD@ATP_low
set termout off
drop user scott cascade;
set termout on
set echo on
show user
pause
create user scott2 identified by tiger;
pause
conn scott/tiger@ATP_low
pause
clear screen
set termout off
conn admin/PASSWORD@ATP_low
set termout on
show user
drop user scott casacde;
pause
host expdp SYSTEM/PASSWORD@SERVICE_NAME directory=tmp dumpfile=scott.dmp schemas=scott
pause
clear screen
host impdp admin@ATP_low directory=data_pump_dir credential=OBJ_STORE_CRED dumpfile=https://o...-bucket/o/SCOTT.DMP

