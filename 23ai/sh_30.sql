clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
noaudit policy col_level_audit;
drop audit policy col_level_audit;
drop table scott.t purge;
create table scott.t 
as select * from scott.emp;
column event_timestamp format a30
column dbusername format a10
column action_name format a20
column object_name format a20
column sql_text format a40
begin
  dbms_audit_mgmt.clean_audit_trail(
   audit_trail_type           =>  dbms_audit_mgmt.audit_trail_unified,
   use_last_arch_timestamp    =>  false,
   container                  =>  dbms_audit_mgmt.container_current );
end;
/

set lines 60
set define off
undefine 1
clear screen
set define '&'
set verify off
set termout on
set echo off
prompt |
prompt |          _    _ _____ _____ _______ 
prompt |     /\  | |  | |  __ \_   _|__   __|
prompt |    /  \ | |  | | |  | || |    | |   
prompt |   / /\ \| |  | | |  | || |    | |   
prompt |  / ____ \ |__| | |__| || |_   | |   
prompt | /_/    \_\____/|_____/_____|  |_|   
prompt |                                     
prompt |                                     
pause
set echo on
clear screen
desc scott.t
pause
create audit policy col_level_audit
  actions select(ename,sal) on scott.t;
pause
audit policy col_level_audit;
pause
set lines 120
clear screen
conn scott/tiger@db23
select empno, deptno, hiredate
from t;
pause
clear screen
select empno, ename,sal
from t;
pause
clear screen
select empno, ename,hiredate
from t;
pause
clear screen
conn sys/SYSTEM_PASSWORD@db23
pause
set echo off
column event_timestamp format a30
column db  format a8
column op format a8
column obj format a10
column sql_text format a40
set echo on
select 
   object_name obj,
   event_timestamp,
   dbusername db,
   action_name op,
   sql_text
from   unified_audit_trail
where  object_name = 'T'
and   object_schema = 'SCOTT'
order by event_timestamp;
pause
noaudit policy col_level_audit;
drop audit policy col_level_audit;

pause Done
