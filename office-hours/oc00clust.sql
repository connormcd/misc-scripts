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
alter table my_transactions1 add clustering by linear order(cust_id,trans_id);
pause
set autotrace traceonly stat

select * from my_transactions1
where cust_id = 160

/
pause
clear screen
alter table my_transactions1 move online;
pause
exec dbms_stats.gather_table_stats('','my_transactions1');
pause

clear screen
set autotrace traceonly stat

select * from my_transactions1
where cust_id = 160

pause
/

set autotrace off
