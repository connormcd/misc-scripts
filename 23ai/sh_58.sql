set termout off
clear screen
@clean
set termout off
conn sys/admin@db23 as sysdba
set termout off
alter system set "_awr_colored_app_enabled" = FALSE;
variable dbid number
begin
delete WRH$_AWRAPP_SQLSTAT_BL;
delete WAPP$_APPMAP_DEF;
delete WRH$_AWRAPP_INFO;
commit;
select dbid into :dbid from v$database;
end;
/
conn dbdemo/dbdemo@db23
set termout off
alter system set "_awr_colored_app_enabled" = TRUE;
exec dbms_awrapp_admin.drop_appmap(appmap_name=>'MY_APPMAP_1');
col snap1 new_value start_snap
col snap2 new_value end_snap
col dbid new_value dbkey
col appmap_name format a25
col module_pat format a25
clear screen
set termout on
set echo off
prompt | 
prompt |   __  __  ____  _   _ _____ _______ ____  _____  _____ _   _  _____ 
prompt |  |  \/  |/ __ \| \ | |_   _|__   __/ __ \|  __ \|_   _| \ | |/ ____|
prompt |  | \  / | |  | |  \| | | |    | | | |  | | |__) | | | |  \| | |  __ 
prompt |  | |\/| | |  | | . ` | | |    | | | |  | |  _  /  | | | . ` | | |_ |
prompt |  | |  | | |__| | |\  |_| |_   | | | |__| | | \ \ _| |_| |\  | |__| |
prompt |  |_|  |_|\____/|_| \_|_____|  |_|  \____/|_|  \_\_____|_| \_|\_____|
prompt |                                                                     
prompt |                                                                     
pause
set echo on
--
-- A common frustration
--
pause
--host &&basedir\awr.png
pause
exec dbms_awrapp_admin.create_appmap(appmap_name=>'MY_APPMAP_1',module_pat=>'%CONNOR%');
pause
exec dbms_workload_repository.include_appmap(appmap_name => 'MY_APPMAP_1');
pause
select  dbms_workload_repository.create_snapshot() snap1;
pause
clear screen
exec dbms_application_info.set_module('CONNOR','');
pause
select count(*) from emp, emp, emp, emp,emp, emp, emp;
pause
exec dbms_application_info.set_module('OTHER','');
pause
select count(*) from dept, emp, emp, emp,emp, emp, emp;
pause
select  dbms_workload_repository.create_snapshot() snap2 from dual;
pause
clear screen
select snap_id, appmap_id, module
from   awr_pdb_awrapp_info;
pause
clear screen
conn sys/admin@db23 as sysdba
pause
set termout off
alter session set "_swrf_test_action"=399;
alter session set "_swrf_test_action" = 324;
select dbid from   AWR_PDB_AWRAPP_INFO where rownum = 1;
set termout on
set echo on
set serveroutput off
set long 10000000
set pages 50000
set lines 5000
set longchunksize 32767
set heading off
set trims on
 
spool &&basedir\awr_application_report.html
select dbms_awrapp.generate_awrapp_report(&&dbkey,&&start_snap,&&end_snap, '1', 'html')

pause
set echo off
set feedback off
/
spool off
alter system set "_awr_colored_app_enabled" = FALSE;
prompt host c:\tmp\awr_application_report.html
pause
set echo on
host &&basedir\awr_application_report.html

pause Done
