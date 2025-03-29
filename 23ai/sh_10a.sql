clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
set termout on
set echo on
conn daily_pay_run/daily_pay_run@db23
pause
select *
from scott.emp
where empno = 7369
for update nowait

pause
/
rem
rem back to session 1
rem
pause

clear screen
conn daily_pay_run/daily_pay_run@db23
pause
alter session set txn_priority = high;
pause
set timing on
select *
from scott.emp
where empno = 7369
for update;
commit;
rem
rem back to session 1
rem
roll;
