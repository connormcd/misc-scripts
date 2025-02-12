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
alter system reset txn_auto_rollback_high_priority_wait_target;
alter system reset txn_auto_rollback_medium_priority_wait_target;
drop user lazy_connor cascade;
drop user sleepy_tom cascade;
drop user daily_payroll_batch cascade;

clear screen
set termout on
set echo on
grant db_developer_role to lazy_connor
identified by lazy_connor;
pause
grant db_developer_role to daily_payroll_batch
identified by daily_payroll_batch;
pause
grant all on scott.emp to lazy_connor;
grant all on scott.emp to daily_payroll_batch;
pause
clear screen
conn lazy_connor/lazy_connor@DB_SERVICE
pause
update scott.emp
set sal = sal + 10
where empno = 7369;
rem
rem over to session 2
rem
pause
roll;
pause
clear screen
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
alter system set txn_auto_rollback_high_priority_wait_target = 20;
pause
conn lazy_connor/lazy_connor@DB_SERVICE
pause
alter session set txn_priority = low;
pause
update scott.emp
set sal = sal + 10
where empno = 7369;
rem
rem over to session 2
rem
pause
select * from dual;
pause

clear screen
set termout off
conn SYS_USER/PASSWORD@MY_PDB
set termout off
clear screen
set termout on
set echo on
clear screen
grant db_developer_role to sleepy_tom
identified by sleepy_tom;
pause
grant all on scott.emp to sleepy_tom;
pause
conn SYSTEM_USER/PASSWORD@DB_SERVICE
pause
alter system set txn_auto_rollback_medium_priority_wait_target = 10;
pause

clear screen
conn lazy_connor/lazy_connor@DB_SERVICE
pause
alter session set txn_priority = low;
pause
update scott.emp
set sal = sal + 10
where empno = 7369;
rem
rem over to session 3
rem
pause
select * from dual;