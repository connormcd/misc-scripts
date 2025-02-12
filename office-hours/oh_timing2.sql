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
col elapsed format 9999.00
clear screen
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
select count(*) 
from user_source, user_procedures;
pause 
set timing on
select count(*) 
from user_source, user_procedures;
pause
set timing off
clear screen
timing start

select count(*) 
from user_source, user_procedures;
select count(*) 
from user_source, user_procedures;
select count(*) 
from user_source, user_procedures;

timing stop
pause
set echo off
clear screen
prompt | SQLcl: Release 24.1 Production on Tue June 18 14:17:57 2024
prompt | 
prompt | Copyright (c) 1982, 2024, Oracle.  All rights reserved.
prompt | 
prompt | Last Successful login time: Tue Jun 18 2024 14:17:58 +08:00
prompt | 
prompt | Connected to:
prompt | Oracle Database 21c Enterprise Edition Release 21.0.0.0.0 - Production
prompt | Version 21.13.0.0.0
prompt | 
prompt | SQL> timing start
prompt | Timing command is obsolete.
prompt | 
set echo on
pause
clear screen
host cat c:\oracle\sql\fake_timer_start.sql
pause
host cat c:\oracle\sql\fake_timer_stop.sql
pause
clear screen
define timer=""
pause
@fake_timer_start T1
pause
@fake_timer_stop T1
pause
clear screen
@fake_timer_start DDL_PHASE
pause
@fake_timer_start DML_PHASE
pause
@fake_timer_stop DML_PHASE
pause
@fake_timer_stop DDL_PHASE
pause
clear screen
@fake_timer_start P1
@fake_timer_start P2
@fake_timer_start P3
pause
clear screen
@fake_timer_stop P2
pause
@fake_timer_stop P3
pause
@fake_timer_stop P1





