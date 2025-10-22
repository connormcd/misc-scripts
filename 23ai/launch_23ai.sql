clear screen
@clean
set termout on
set termout off
conn dbdemo/dbdemo@db23
set feedback off
clear screen
prompt Prepping....
set termout off
conn dbdemo/dbdemo@db19
set termout off
host del load50.sql
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

spool load50.sql
/
spool off
@load50.sql
set pages 99
set feedback on
conn dbdemo/dbdemo@db23
set termout off
host del load50b.sql
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

spool load50b.sql
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
        ,'**missing**     '  --46
        ,'INDEX SIZE       '  --47
        ,'COOL GROUP BY    '  --48
        ,'REUSE OBJECT#'  --49
        ,'IN-LIST'  --50
        ,'VIRTUAL'  --51
        ,'**missing**'  --52
        ,'**missing**'  --53
        ,'DYNAMIC SAMPLING'  --54
        ,'ORA-4068'  --55
        ,'EASY JSON LOAD'  --56
        ,'DOMAIN ENUM'  --57
        ,'**missing**'  --58
        ,'TABLE ACCESS'  --59
        ,'JAVASCRIPT'  --60
        ,'METADATA'  --61
        ,'TIME BUCKET'  --62
        ,'BETTER MERGE'  --63
        ,'NEW INSERT'  --64
        ,'UUID / GUID'  --65
        ,'REDACT'  --66
        ,'TIME_AT_DBTIMEZONE'  --67
        ,'**missing**'  --68
        ,'HYBRID VECTOR INDEX'  --69
        ,'MEMOPTIMIZE WRITES'  --70
        ,'**missing**'  --71
        ,'**missing**'  --72
        ,'SECURE AUDIT'  --73
        ,'**missing**'  --74
        ,'ETAG'  --75
        ,'**missing**'  --76
        ,'WHERE 2.0'  --77
        ,'**missing**'  --78
        ,'**missing**'  --79
        ,'**missing**' -- 80
        ,'SESSION MURDER' -- 81
        ,'**missing**' -- 82
        ,'**missing**' -- 83
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
set termout off
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
prompt |     _   _  ____       _____ _      _____ _____  ______  _____     _   _   _ 
prompt |    | \ | |/ __ \     / ____| |    |_   _|  __ \|  ____|/ ____|   | | | | | |
prompt |    |  \| | |  | |   | (___ | |      | | | |  | | |__  | (___     | | | | | |
prompt |    | . ` | |  | |    \___ \| |      | | | |  | |  __|  \___ \    | | | | | |
prompt |    | |\  | |__| |    ____) | |____ _| |_| |__| | |____ ____) |   |_| |_| |_|
prompt |    |_| \_|\____/    |_____/|______|_____|_____/|______|_____/    (_) (_) (_)
prompt |                                                                             
prompt |
pause
clear screen
prompt | 
prompt | 
prompt |   _   _ ________          __     ______ ______       _______ _    _ _____  ______  _____ 
prompt |  | \ | |  ____\ \        / /    |  ____|  ____|   /\|__   __| |  | |  __ \|  ____|/ ____|
prompt |  |  \| | |__   \ \  /\  / /     | |__  | |__     /  \  | |  | |  | | |__) | |__  | (___  
prompt |  | . ` |  __|   \ \/  \/ /      |  __| |  __|   / /\ \ | |  | |  | |  _  /|  __|  \___ \ 
prompt |  | |\  | |____   \  /\  /       | |    | |____ / ____ \| |  | |__| | | \ \| |____ ____) |
prompt |  |_| \_|______|   \/  \/        |_|    |______/_/    \_\_|   \____/|_|  \_\______|_____/ 
prompt |                                                                                          
prompt |                                                                                          
prompt |                                                                                         
prompt |                                                                                         
pause
clear screen
prompt |  
prompt |  SAFE HARBOR
prompt |  
prompt |  The following is intended to outline our general product direction.
prompt |  It is intended for information purposes only, and may not be incorporated into any contract. 
prompt |  It is not a commitment to deliver any material, code, or functionality, and should not 
prompt |  be relied upon in making purchasing decisions. The development, release, timing, and 
prompt |  pricing of any features or functionality described for Oracle’s products may change 
prompt |  and remains at the sole discretion of Oracle Corporation.
prompt |  
prompt |    ie, if you can't find it in the docs, you're on your own ! :-)
prompt |  
pause
clear screen
prompt |  
prompt |  
prompt |    _      ______ _______ _____     _____  ____     _   _   _   _ 
prompt |   | |    |  ____|__   __/ ____|   / ____|/ __ \   | | | | | | | |
prompt |   | |    | |__     | | | (___    | |  __| |  | |  | | | | | | | |
prompt |   | |    |  __|    | |  \___ \   | | |_ | |  | |  | | | | | | | |
prompt |   | |____| |____   | |  ____) |  | |__| | |__| |  |_| |_| |_| |_|
prompt |   |______|______|  |_| |_____/    \_____|\____/   (_) (_) (_) (_)
prompt |                                                                  
prompt |  
prompt |  
pause
clear screen
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql

@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
@menu.sql
