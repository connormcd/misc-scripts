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
drop user jane_doe cascade;
drop user lowly_peasant cascade;
drop user ceo cascade;

clear screen
set termout on
set echo on
grant db_developer_role to lowly_peasant
identified by lowly_peasant;
pause
grant db_developer_role to ceo
identified by ceo;
pause
grant all on scott.emp to lowly_peasant;
grant all on scott.emp to ceo;
pause
clear screen
conn lowly_peasant/lowly_peasant@DB_SERVICE
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
alter system set txn_auto_rollback_high_priority_wait_target = 10;
pause
clear screen
conn lowly_peasant/lowly_peasant@DB_SERVICE
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
