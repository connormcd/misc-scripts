REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

pause
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set termout off
alter session set "_serial_direct_read" = never;
@drop t
set echo on
clear screen
set termout on
show sga
pause
clear screen
create table t as 
select d.* from dba_objects d,
  ( select 1 from dual connect by level <= 40 );
pause
alter system flush buffer_cache;

set timing on  
select count(*), max(object_id) from t;
pause
/
set timing off
pause

clear screen
update t 
set owner = lower(owner);
commit;
pause

select
  s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.statistic# in ( 675, 677, 684, 685, 686, 687, 688, 689 );
pause

clear screen
set timing on  
select count(*), max(object_id) from t;
set timing off  
pause

select
  s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.statistic# in ( 675, 677, 684, 685, 686, 687, 688, 689 );
pause

select     num_rows,blocks
from       user_tables
where      table_name = 'T';
pause

set timing on  
select count(*), max(object_id) from t;
set timing off  

set echo off
pro BOUNCING DB TO RESET OR CTRL-C
pause
REM conn / as sysdba
REM startup force pfile=c:\temp\small.ora
