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
undefine objnum 
clear screen
set timing off
set time off
set pages 999
@drop t
set lines 60
set verify off
set termout on
col statistic_name format a35
clear screen
set feedback on
set echo on
create table t
as select * from dba_objects;
pause
clear screen
col object_id new_value objnum
select object_id
from   user_objects
where  object_name = 'T';
pause
desc v$segstat
pause
clear screen
select distinct statistic_name
from v$segstat;
pause
set lines 200
clear screen
select statistic_name, value
from v$segstat
where obj# = &&objnum;
pause
select count(owner) 
from t;
pause
/
/
/
pause
select statistic_name, value
from v$segstat
where obj# = &&objnum;
pause
delete from t;
commit;

pause
select statistic_name, value
from v$segstat
where obj# = &&objnum;
