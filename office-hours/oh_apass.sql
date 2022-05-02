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
REM
REM Prelim
REM
REM drop user scott cascade;
REM impdp admin/PASSWORD@ATP_low directory=data_pump_dir credential=DEF_CRED_NAME dumpfile=https://.../bucket1/o/SCOTT.DMP
REM 
host del x:\tmp\scott.dmp
clear screen
REM conn ADMIN/PASSWORD@ATP_low
set termout off
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
conn ADMIN/PASSWORD@ATP_low
set termout on
show user
drop user scott cascade;
pause
host expdp SYSTEM/PASSWORD@SERVICE_NAME directory=tmp dumpfile=scott.dmp schemas=scott
pause
clear screen
REM
REM
REM oci os object put --bucket-name https://.../bucket1 --file scott.dmp
REM
REM
pause
host impdp admin@ATP_low directory=data_pump_dir credential=DEF_CRED_NAME dumpfile=https://...o/SCOTT.DMP
pause
clear screen
select *
from   dba_users
where  username = 'SCOTT'
@pr
pause
alter user scott identified by simple;
pause
alter user scott identified by MyS3cretPassw0rd;




