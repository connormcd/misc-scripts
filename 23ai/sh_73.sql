clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
noaudit policy reveal_secrets;
drop audit policy reveal_secrets;
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
begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED',
    force=>true);
end;
/

begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED1',
    force=>true);
end;
/

begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED2',
    force=>true);
end;
/

begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED3',
    force=>true);
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
prompt |  
prompt |     _____ ______ _____ _    _ _____  ______            _    _ _____ _____ _______ 
prompt |    / ____|  ____/ ____| |  | |  __ \|  ____|      /\  | |  | |  __ \_   _|__   __|
prompt |   | (___ | |__ | |    | |  | | |__) | |__        /  \ | |  | | |  | || |    | |   
prompt |    \___ \|  __|| |    | |  | |  _  /|  __|      / /\ \| |  | | |  | || |    | |   
prompt |    ____) | |___| |____| |__| | | \ \| |____    / ____ \ |__| | |__| || |_   | |   
prompt |   |_____/|______\_____|\____/|_|  \_\______|  /_/    \_\____/|_____/_____|  |_|   
prompt |                                                                                   
prompt |                                                                                   
prompt |                                     
prompt |                                     
pause
set echo on
clear screen
create audit policy reveal_secrets
  actions execute on sys.dbms_credential;
pause
audit policy reveal_secrets;
pause
set lines 120
clear screen
begin
  dbms_credential.create_credential(
    credential_name=>'TMP_OBJ_STORE_CRED1',
    username       =>'MYUSER',
    password       =>'MySecretPassword');
end;
/
pause
clear screen
conn sys/admin@db23 as sysdba
pause
select 
   object_name obj,
   event_timestamp,
   dbusername db,
   action_name op,
   sql_text
from   unified_audit_trail
where object_name = 'DBMS_CREDENTIAL'
order by event_timestamp desc
fetch first 1 row only
@pr
pause
conn dbdemo/dbdemo@db23
clear screen
set echo on
variable pass varchar2(60)
exec :pass := 'MySecretPassword';
pause
begin
  dbms_credential.create_credential(
    credential_name=>'TMP_OBJ_STORE_CRED2',
    username       =>'MYUSER',
    password       =>:pass);
end;
/
pause
clear screen
conn sys/admin@db23 as sysdba
pause
select 
   object_name obj,
   event_timestamp,
   dbusername db,
   action_name op,
   sql_text,
   sql_binds
from   unified_audit_trail
where object_name = 'DBMS_CREDENTIAL'
order by event_timestamp desc
fetch first 1 row only
@pr

pause
clear screen
alter system set unified_audit_trail_exclude_columns=SQL_TEXT scope=spfile;
shutdown immediate
startup
pause

conn dbdemo/dbdemo@db23
clear screen
set echo on
begin
  dbms_credential.create_credential(
    credential_name=>'TMP_OBJ_STORE_CRED3',
    username       =>'MYUSER',
    password       =>'MySecretPassword');
end;
/
pause
clear screen
conn sys/admin@db23 as sysdba
pause
select 
   object_name obj,
   event_timestamp,
   dbusername db,
   action_name op,
   sql_text
from   unified_audit_trail
where object_name = 'DBMS_CREDENTIAL'
order by event_timestamp desc
fetch first 1 row only
@pr

pause
--
-- SQL_TEXT
-- SQL_BINDS
-- RLS_INFO
-- DP_CLOB_PARAMETERS1
-- NONE (Default)
--
pause

-- Cleaning up
set termout off
noaudit policy reveal_secrets;
drop audit policy reveal_secrets;
begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED',
    force=>true);
end;
/

begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED1',
    force=>true);
end;
/

begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED2',
    force=>true);
end;
/

begin
  dbms_credential.drop_credential(
    credential_name => 'TMP_OBJ_STORE_CRED3',
    force=>true);
end;
/
alter system reset unified_audit_trail_exclude_columns scope=spfile;
shutdown immediate
startup
set termout on
set echo on

pause Done








