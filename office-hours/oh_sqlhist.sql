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
conn SYS_USER/PASSWORD@MY_PDB as sysdba
set termout off
alter system set sql_history_enabled = false scope=spfile;
shutdown immediate
startup
conn SYS_USER/PASSWORD@MY_PDB
set termout off
@drop porn_subscription
create table porn_subscription as select * from user_objects;
set echo on
set termout on
clear screen
set lines 70
desc v$sql_history
pause
set lines 120
clear screen
select * from v$sql_history;
pause
alter session set sql_history_enabled = true;
pause
select count(*) from emp;
select count(*) from dept;
pause
select * from v$sql_history;
pause
clear screen
conn SYS_USER/PASSWORD@MY_PDB as sysdba
alter system set sql_history_enabled = true scope=spfile;
pause
shutdown immediate
startup
pause
set termout off
clear screen
conn SYS_USER/PASSWORD@MY_PDB
show user
pause
select count(*) from emp;
select count(*) from dept;
pause
col sql_text format a60 trunc
col err format 9999
clear screen
select 
  sql_id, 
  to_char(last_active_time,'HH24:MI:SS') last_run,
  cpu_time,
  error_number err,
  replace(sql_text,chr(10),' ') sql_text
from v$sql_history;
pause
clear screen
alter session set sql_history_enabled = false;
pause
select count(*)
from porn_subscription;
pause
select 
  sql_id, 
  to_char(last_active_time,'HH24:MI:SS') last_run,
  cpu_time,
  error_number err,
  replace(sql_text,chr(10),' ') sql_text
from v$sql_history;
pause
clear screen
alter session set sql_history_enabled = true;
pause
select 
  sql_id, 
  to_char(last_active_time,'HH24:MI:SS') last_run,
  cpu_time,
  error_number err,
  replace(sql_text,chr(10),' ') sql_text
from v$sql_history;
pause
select count(*) from emp;
select count(*) from dept;
pause
select 
  sql_id, 
  to_char(last_active_time,'HH24:MI:SS') last_run,
  cpu_time,
  error_number err,
  replace(sql_text,chr(10),' ') sql_text
from v$sql_history;
pause
clear screen
--
-- NOTE
--
select distinct sid 
from v$sql_history;
pause
select count(*) 
from my_non_existent_table;
pause
select 
  sql_id, 
  to_char(last_active_time,'HH24:MI:SS') last_run,
  cpu_time,
  error_number err,
  replace(sql_text,chr(10),' ') sql_text
from v$sql_history;
