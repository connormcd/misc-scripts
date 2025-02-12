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
set timing off
set time off
set pages 999
set termout on
clear screen
set echo on
select count(*) 
from user_source, user_source;
pause 
set timing on
select count(*) 
from user_source, user_source;
pause
set timing off
clear screen
timing start

select count(*) 
from user_source, user_source;
select count(*) 
from user_source, user_source;
select count(*) 
from user_source, user_source;

timing stop

pause
clear screen
timing start overall
timing start query1

select count(*) 
from user_source, user_source;
timing stop query1


select count(*) 
from user_source, user_source;
select count(*) 
from user_source, user_source;
timing stop overall

pause
set time on
clear screen
timing start query1and2

select count(*) 
from user_source, user_source;

timing start query2and3

select count(*) 
from user_source, user_source;

timing stop query1and2

select count(*) 
from user_source, user_source;

timing stop query2and3

pause
set time on
clear screen
timing start overall

select count(*) 
from user_source, user_source;

timing show overall

select count(*) 
from user_source, user_source;

timing show overall

select count(*) 
from user_source, user_source;

timing stop overall

set time off
set timing off
