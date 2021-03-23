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
conn USERNAME/PASSWORD@DATABASE_SERVICE
set termout off
col begin_interval_time format a36
col end_interval_time format a36
set lines 120
undefine last_snap
set termout on
set echo on
clear screen
alter session set nls_date_format = 'dd/mm/yyyy hh24:mi:ss';
select sysdate from dual;
set echo off
pro
pro Press Enter to create a snapshot, whilst
pro session 1 is running
pro
set echo on
pause
select sysdate from dual;
exec dbms_workload_repository.create_snapshot;
set echo off
pro
pro Now wait for session 1 to finish
pro
set echo on
pause
select sysdate from dual;
exec dbms_workload_repository.create_snapshot;
pause
clear screen
col snap_id new_value last_snap
select snap_id, begin_interval_time, end_interval_time
from   dba_hist_snapshot
where  con_id = 3
order by begin_interval_time desc
fetch first 1 row only;
pause

select min(sample_time)
from dba_hist_active_sess_history
where snap_id = &&last_snap
and  user_id = 195
and con_id = 3;

set termout off
conn / as sysdba
set termout off
alter system set "_ash_disk_filter_ratio" = 10;
set termout on
