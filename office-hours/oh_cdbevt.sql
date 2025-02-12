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
conn / as sysdba
set termout off
alter pluggable database pdb21b close immediate;
conn USER/PASSWORD@MY_PDB
set termout off
set timing off
@drop latch1
@drop latch2
@drop t
col event format a24
set pages 999
set termout on
clear screen
set echo on
conn / as sysdba
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
conn /@DB_SERVICE as sysdba
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
exec dbms_session.sleep(3);
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
clear screen
conn / as sysdba
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
clear screen
alter pluggable database pdb21b open;
pause
conn /@pdb21b as sysdba
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
exec dbms_session.sleep(3);
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
conn / as sysdba
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
exec dbms_session.sleep(3);
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
pause
conn /@DB_SERVICE as sysdba
pause
select event, wait_time_milli, wait_count
from  v$event_histogram
where event like 'PL/SQL%timer%';
