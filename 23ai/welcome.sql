clear screen
@clean
set termout on
set termout off
conn dbdemo/dbdemo@db23
set feedback off
select chr(27)||'[0m' from dual;
clear screen
prompt Prepping....
set termout off
conn dbdemo/dbdemo@db19
set termout off
host del instantclient_26\sql\load50.sql
set pages 0
set feedback off
set termout off
select case when count(*) = 3 then 'rem ' end ||'@sh_50_load.sql'
from user_tables
where (table_name,num_rows) in
(
  ('COMPANY',5000),
  ('ORGANISATION',11),
  ('SERVICE_CALLS',3474)
)

spool instantclient_26\sql\load50.sql
/
spool off
@load50.sql
set pages 99
set feedback on
conn dbdemo/dbdemo@db23
set termout off
host del instantclient_26\sql\load50b.sql
set pages 0
set feedback off
set termout off
select case when count(*) = 3 then 'rem ' end ||'@sh_50_load.sql'
from user_tables
where (table_name,num_rows) in
(
  ('COMPANY',5000),
  ('ORGANISATION',11),
  ('SERVICE_CALLS',3474)
)

spool instantclient_26\sql\load50b.sql
/
spool off
@load50b.sql
set pages 99

create table mega_emp as
select e.* from emp e,
 ( select 1 connect by level <= 1000 ),
 ( select 1 connect by level <= 2000 );
set termout off
begin
  dbms_audit_mgmt.clean_audit_trail(
   audit_trail_type           =>  dbms_audit_mgmt.audit_trail_unified,
   use_last_arch_timestamp    =>  false,
   container                  =>  dbms_audit_mgmt.container_current );
end;
/
set feedback off
@drop t
set define off
undefine 1
clear screen
set define '&'
set verify off
set echo off
clear screen
@drop tmenu
create table tmenu ( c clob);
declare
  s sys.odcivarchar2list := sys.odcivarchar2list(
         'SELECT-FROM    '  --1
        ,'BOOLEAN        '  --2
        ,'GROUP BY       '  --3
        ,'IF EXISTS      '  --4
        ,'RETURNING      '  --5
        ,'ONE LIVE DEV   '  --6
        ,'MULTI DIRECT   '  --7
        ,'JSON DUALITY   '  --8
        ,'TRANSPILER     '  --9
        ,'TXN PRIORITY   '  --10
        ,'SQL ANALYSIS   '  --11
        ,'SQL HISTORY    '  --12
        ,'READ ONLY      '  --13
        ,'UPDATE JOIN    '  --14
        ,'AGG INTERVAL   '  --15
        ,'LOB RENAME     '  --16
        ,'MAX COLUMNS    '  --17
        ,'DBMS_SEARCH    '  --18
        ,'OBJECT - JSON  '  --19
        ,'JSON - OBJECT  '  --20
        ,'FIREWALL       '  --21
        ,'SQLPLUS        '  --22
        ,'ANNOTATIONS    '  --23
        ,'SHRINK TSPACE  '  --24
        ,'JSON SCHEMA      '  --25
        ,'ARGUMENT         '  --26
        ,'PHONICS          '  --27
        ,'LONG LOBS        '  --28
        ,'RESULT CACHE     '  --29
        ,'AUDIT            '  --30
        ,'HYBRID READ ONLY '  --31
        ,'JSON TRANSFORM   '  --32
        ,'UPDATE ON NULL   '  --33
        ,'DBMS_HCHECK      '  --34
        ,'WALLET           '  --35
        ,'SO MUCH JSON     '  --36
        ,'VECTOR           '  --37
        ,'PAGINATION       '  --38
        ,'JSON COLLECTION  '  --39
        ,'NO LONG          '  --30
        ,'STAGING          '  --41
        ,'RESERVABLE       '  --42
        ,'MVIEW REWRITE    '  --43
        ,'MESSAGES         '  --44
        ,'SESSIONLESS TXN  '  --45
        ,'NEW VARCHAR2     '  --46
        ,'INDEX SIZE       '  --47
        ,'COOL GROUP BY    '  --48
        ,'REUSE OBJECT#'  --49
        ,'IN-LIST'  --50
        ,'VIRTUAL'  --51
        ,'SECUREFILE MIGRATION'  --52
        ,'ROW TRACKING'  --53
        ,'DYNAMIC SAMPLING'  --54
        ,'ORA-4068'  --55
        ,'EASY JSON LOAD'  --56
        ,'DOMAIN ENUM'  --57
        ,'EASY WAIT'  --58
        ,'TABLE ACCESS'  --59
        ,'JAVASCRIPT'  --60
        ,'METADATA'  --61
        ,'TIME BUCKET'  --62
        ,'BETTER MERGE'  --63
        ,'NEW INSERT'  --64
        ,'UUID / GUID'  --65
        ,'REDACT'  --66
        ,'TIME_AT_DBTIMEZONE'  --67
        ,'JSON_DIFF'  --68
        ,'HYBRID VECTOR INDEX'  --69
        ,'MEMOPTIMIZE WRITES'  --70
        ,'ORA-4068 PART 2'  --71
        ,'DYNAMIC SQL'  --72
        ,'SECURE AUDIT'  --73
        ,'INTEGRITY 2.0'  --74
        ,'ETAG'  --75
        ,'DATE DIFF'  --76
        ,'WHERE 2.0'  --77
        ,'UTL_FILE'  --78
        ,'PARTITION EXPR'  --79
        ,'DATA MODELLING' -- 80
        ,'SESSION MURDER' -- 81
        ,'TRUNCATE' -- 82
        ,'GRAPHQL' -- 83
        );
  v varchar2(32000);        
  l_rows int := 21;
  l_cols int := ceil(s.count/l_rows);
  l_idx  int;
  l_pad  sys.odcinumberlist := sys.odcinumberlist();
begin
  l_pad.extend(l_cols);
  for i in 1 .. s.count loop
    l_pad(trunc((i-1)/l_rows)+1) := 
      greatest(nvl(l_pad(trunc((i-1)/l_rows)+1),0), length(s(i)));
  end loop;
  for i in 1 .. l_rows loop
    for j in 1 .. l_cols loop
      l_idx :=  (j-1)*l_rows + i;
      exit when l_idx > s.count;
      v := v || lpad(l_idx,2,'0')||')  '||rpad(s(l_idx),l_pad(j)+1);
    end loop;
    v := v || chr(10);
 end loop;
 insert into tmenu values (v); commit;
end;
/
set timing off
set time off
set pages 999
set lines 200
set long 20000
set longchunksize 20000
set termout on
set serverout on
set echo off
clear screen
prompt |
prompt |
prompt |
prompt |
prompt |
prompt |        
prompt |     __          __  ______   _         _____    ____    __  __   ______    _    _    _ 
prompt |     \ \        / / |  ____| | |       / ____|  / __ \  |  \/  | |  ____|  | |  | |  | |
prompt |      \ \  /\  / /  | |__    | |      | |      | |  | | | \  / | | |__     | |  | |  | |
prompt |       \ \/  \/ /   |  __|   | |      | |      | |  | | | |\/| | |  __|    | |  | |  | |
prompt |        \  /\  /    | |____  | |____  | |____  | |__| | | |  | | | |____   |_|  |_|  |_|
prompt |         \/  \/     |______| |______|  \_____|  \____/  |_|  |_| |______|  (_)  (_)  (_)
prompt |                                                                                        
prompt |                                                                                        
prompt |               Note: This is the font size for code
prompt |    
prompt |    
prompt |    
pause
