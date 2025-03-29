clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
begin
  dbms_audit_mgmt.clean_audit_trail(
   audit_trail_type           =>  dbms_audit_mgmt.audit_trail_unified,
   use_last_arch_timestamp    =>  false,
   container                  =>  dbms_audit_mgmt.container_current );
end;
/

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
  v varchar2(2000) :=
'01)  SELECT-FROM    17)  MAX COLUMNS      35)  WALLET
02)  BOOLEAN        18)  DBMS_SEARCH      36)  SO MUCH JSON
03)  GROUP BY       19)  OBJECT - JSON    37)  VECTOR
04)  IF EXISTS      20)  JSON - OBJECT    38)  PAGINATION
05)  RETURNING      21)  FIREWALL         39)  JSON COLLECTION
06)  ONE LIVE DEV   22)  SQLPLUS          40)  NO LONG
07)  MULTI DIRECT   23)  ANNOTATIONS      41)  STAGING
08)  JSON DUALITY   24)  SHRINK TSPACE    42)  RESERVABLE
09)  TRANSPILER     25)  JSON SCHEMA      43)  MVIEW REWRITE
10)  TXN PRIOITY    27)  PHONICS          51)  VIRTUAL
11)  SQL ANALYSIS   28)  LONG LOBS        53)  ROW TRACKING
12)  SQL HISTORY    30)  AUDIT            55)  ORA-4068
13)  READ ONLY      31)  HYBRID READ ONLY 56)  EASY JSON LOAD
14)  UPDATE JOIN    32)  JSON TRANSFORM   57)  DOMAIN ENUM
15)  AGG INTERVAL   33)  UPDATE ON NULL   62)  TIME BUCKET
16)  LOB RENAME     34)  DBMS_HCHECK      59)  TABLE ACCESS
44)  MESSAGES       45)  SESSIONLESS TXN  60)  JAVASCRIPT
61)  METADATA   ';

begin
 insert into tmenu values (v); commit;
end;
/
set timing off
set time off
set pages 999
set lines 200
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
prompt |   ___  ____          _____      ______ ______       _______ _    _ _____  ______  _____ 
prompt |  |__ \|___ \   /\   |_   _|    |  ____|  ____|   /\|__   __| |  | |  __ \|  ____|/ ____|
prompt |     ) | __) | /  \    | |      | |__  | |__     /  \  | |  | |  | | |__) | |__  | (___  
prompt |    / / |__ < / /\ \   | |      |  __| |  __|   / /\ \ | |  | |  | |  _  /|  __|  \___ \ 
prompt |   / /_ ___) / ____ \ _| |_     | |    | |____ / ____ \| |  | |__| | | \ \| |____ ____) |
prompt |  |____|____/_/    \_\_____|    |_|    |______/_/    \_\_|   \____/|_|  \_\______|_____/ 
prompt |                                                                                         
prompt |                                                                                         
prompt |                                                                                         
pause
clear screen
prompt |
prompt |  _________          _______ _______ _______ ______ _____  
prompt | |__   __\ \        / /_   _|__   __|__   __|  ____|  __ \ 
prompt |    | |   \ \  /\  / /  | |    | |     | |  | |__  | |__) |
prompt |    | |    \ \/  \/ /   | |    | |     | |  |  __| |  _  / 
prompt |    | |     \  /\  /   _| |_   | |     | |  | |____| | \ \ 
prompt |    |_|      \/  \/   |_____|  |_|     |_|  |______|_|  \_\
prompt |                                                           
prompt |                                                           
prompt |
prompt |             _____ ____  _   _ _   _  ____  _____             __  __  _____            _____  
prompt |    ____    / ____/ __ \| \ | | \ | |/ __ \|  __ \           |  \/  |/ ____|          |  __ \ 
prompt |   / __ \  | |   | |  | |  \| |  \| | |  | | |__) |          | \  / | |               | |  | |
prompt |  / / _` | | |   | |  | | . ` | . ` | |  | |  _  /           | |\/| | |               | |  | |
prompt | | | (_| | | |___| |__| | |\  | |\  | |__| | | \ \           | |  | | |____           | |__| |
prompt |  \ \__,_|  \_____\____/|_| \_|_| \_|\____/|_|  \_\          |_|  |_|\_____|          |_____/ 
prompt |   \____/                                            ______                   ______          
prompt |                                                    |______|                 |______|         
prompt |
pause
clear screen
prompt | 
prompt |  __     ______  _    _ _______ _    _ ____  ______ 
prompt |  \ \   / / __ \| |  | |__   __| |  | |  _ \|  ____|
prompt |   \ \_/ / |  | | |  | |  | |  | |  | | |_) | |__   
prompt |    \   /| |  | | |  | |  | |  | |  | |  _ <|  __|  
prompt |     | | | |__| | |__| |  | |  | |__| | |_) | |____ 
prompt |     |_|  \____/ \____/   |_|   \____/|____/|______|
prompt |                                                    
prompt | 
prompt |             _____        _        _                    _____            _      
prompt |     ____   |  __ \      | |      | |                  |  __ \          | |     
prompt |    / __ \  | |  | | __ _| |_ __ _| |__   __ _ ___  ___| |  | |_   _  __| | ___ 
prompt |   / / _` | | |  | |/ _` | __/ _` | '_ \ / _` / __|/ _ \ |  | | | | |/ _` |/ _ \
prompt |  | | (_| | | |__| | (_| | || (_| | |_) | (_| \__ \  __/ |__| | |_| | (_| |  __/
prompt |   \ \__,_| |_____/ \__,_|\__\__,_|_.__/ \__,_|___/\___|_____/ \__,_|\__,_|\___|
prompt |    \____/                                                                      
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
REM @sh_sun
REM pause

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
