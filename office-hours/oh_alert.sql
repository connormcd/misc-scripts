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
@drop local_alert
col container_name format a25
col name format a40
col value format a60
set lines 140
set termout on
clear screen
set echo on
select name, value
from v$diag_info;
pause
clear screen
select view_name
from   v$fixed_view_definition
where  view_name like 'V%DIAG%';
pause
select view_name
from   v$fixed_view_definition
where  view_name like 'V%DIAG%ALERT%'
order by 1;
pause
clear screen
select object_name
from   dba_objects
where  object_name like 'V$%DIAG%'
order by 1

pause
/
pause
select object_name
from   dba_objects
where  object_name like 'V$%DIAG%ALERT%'
order by 1;
pause
clear screen
set lines 80
desc v$diag_alert_ext
pause
set lines 120
clear screen
col originating_timestamp format a15
col module_id format a18 trunc
col process_Id format a10
col filename format a20
col message_text format a60 trunc
set lines 200
clear screen
select 
  to_char(originating_timestamp,'DD/MM HH24:MI:SS') originating_timestamp,
  module_id, 
  process_id, 
  substr(filename,-20,20) filename, 
  message_text
from v$diag_alert_ext
where originating_timestamp > sysdate - 1
order by originating_timestamp;
pause
clear screen
show con_id
pause
select distinct con_id 
from  v$diag_alert_ext;
pause
conn / as sysdba
pause
select container_name, count(*)
from  v$diag_alert_ext
group by container_name;
pause
set echo off
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set termout off
col container_name format a25
col name format a40
col value format a60
col ts_start format a40
col ts_end format a40
set lines 140
set termout on
set echo on
select con_id, container_name, count(*)
from  v$diag_alert_ext
group by con_id, container_name;
pause
select min(originating_timestamp)
from v$diag_alert_ext;
pause
set echo off
pro
pro Over to ATP
pro
set echo on
pause
clear screen
create table local_alert as
select * from v$diag_alert_ext;
pause
select 
  min(originating_timestamp) ts_start,
  max(originating_timestamp) ts_end
from local_alert;
pause
clear screen
create tablespace myts datafile 'X:\ORACLE\ORADATA\DB19\PDB1\MYTS.DBF' size 10m;
pause
drop tablespace myts including contents and datafiles;
pause
insert into local_alert
select *
from v$diag_alert_ext
where originating_timestamp >
 ( select max(originating_timestamp)
   from   local_alert
 );
pause
clear screen
select 
  to_char(originating_timestamp,'DD/MM HH24:MI:SS') originating_timestamp,
  module_id, 
  process_id, 
  substr(filename,-20,20) filename, 
  message_text
from v$diag_alert_ext
where originating_timestamp > sysdate - 1
order by originating_timestamp;

       
       
