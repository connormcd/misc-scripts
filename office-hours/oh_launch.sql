REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@clean
set termout off
conn SYSTEM_USER/PASSWORD@DB_SERVICE
set termout off
clear screen
@drop t
create table t ( c clob);
declare
  v varchar2(1000) :=
'01)  SELECT-FROM    17)  MAX COLUMNS      35)  WALLET
02)  BOOLEAN        18)  DBMS_SEARCH      36)  SO MUCH JSON
03)  GROUP BY       19)  OBJECT - JSON    37)  VECTOR
04)  IF EXISTS      20)  JSON - OBJECT    38)  PAGINATION
05)  RETURNING      21)  FIREWALL         39)  JSON COLLECTION
06)  ONE LIVE DEV   22)  SQLPLUS          40)  NO LONG
07)  MULTI DIRECT   23)  ANNOTATIONS      41)  STAGING
08)  JSON DUALITY   25)  JSON SCHEMA      42)  RESERVABLE
09)  TRANSPILER     26)  ARGUMENT         43)  MVIEW REWRITE
10)  TXN PRIOITY    27)  PHONICS          51)  VIRTUAL
11)  SQL ANALYSIS   28)  LONG LOBS        53)  ROW TRACKING
12)  SQL HISTORY    30)  AUDIT            55)  ORA-4068
13)  READ ONLY      31)  HYBRID READ ONLY 56)  EASY JSON LOAD
14)  UPDATE JOIN    32)  JSON TRANSFORM   57)  DOMAIN ENUM
15)  AGG INTERVAL   33)  UPDATE ON NULL   58)  MONITORING
16)  LOB RENAME     34)  DBMS_HCHECK      59)  TABLE ACCESS';

begin
 insert into t values (v); commit;
end;
/
set timing off
set time off
set pages 999
set lines 200
set termout on
set serverout on
clear screen
set feedback on
set echo on
host ( head -30 c:\oracle\sql\oh_launch.sql )
pause
clear screen
host ( tail -10 c:\oracle\sql\oh_launch.sql )
pause
clear screen
host ( cat c:\oracle\sql\oh_menu_.sql )
pause
clear screen
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
@oh_menu.sql
