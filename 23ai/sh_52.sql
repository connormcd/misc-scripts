clear screen
@clean
set termout off
conn sys/admin@db23 as sysdba
set termout off
drop table sys.migration_config purge;
grant execute on dbms_redefinition to dbdemo;
conn dbdemo/dbdemo@db23
set termout off
drop user tmpuser cascade;
@drop t1
@drop t2
@drop T1_INT1
@drop T2_INT2
set termout off
clear screen
col LAST_ACCESSED_TIME format a30
set lines 90
set termout on
set echo off
prompt |  
prompt |    ______           _______     __      _____ ______ _____ _    _ _____  ______ ______ _____ _      ______ 
prompt |   |  ____|   /\    / ____\ \   / /     / ____|  ____/ ____| |  | |  __ \|  ____|  ____|_   _| |    |  ____|
prompt |   | |__     /  \  | (___  \ \_/ /     | (___ | |__ | |    | |  | | |__) | |__  | |__    | | | |    | |__   
prompt |   |  __|   / /\ \  \___ \  \   /       \___ \|  __|| |    | |  | |  _  /|  __| |  __|   | | | |    |  __|  
prompt |   | |____ / ____ \ ____) |  | |        ____) | |___| |____| |__| | | \ \| |____| |     _| |_| |____| |____ 
prompt |   |______/_/    \_\_____/   |_|       |_____/|______\_____|\____/|_|  \_\______|_|    |_____|______|______|
prompt |                                                                                                            
prompt |               
prompt |  NOTE: For this demo to run, you need to get the official "securefile_migration_script.sql" from the software distro
prompt |                                                                          
pause
set echo on
clear screen
create table t1 ( x int primary key, c1 clob ) lob ( c1) store as basicfile ;
create table t2 ( x int primary key, c2 clob ) lob ( c2) store as basicfile ;
pause
insert into t1
select rownum, rpad('x',1000)
connect by level <= 100;
insert into t2
select rownum, rpad('x',1000)
connect by level <= 100;
commit;
pause
clear screen
create table T1_INT1 ( x int, c1 clob ) lob ( c1) store as securefile ;
create table T2_INT2 ( x int, c2 clob ) lob ( c2) store as securefile ;
pause
clear screen
conn sys/admin@db23 as sysdba
pause
create table migration_config 
  (ctime date, 
   data clob , 
   constraint c1 check(data is json)
);
pause
create user tmpuser;
alter user tmpuser quota 200m on users;
pause
clear screen
begin
delete migration_config ;
insert into migration_config values
    (systimestamp,
    '{"schema_name" : ["DBDEMO"],
    "table_name" : ["DBDEMO.T1", "DBDEMO.T2"],
    "column_name" : ["DBDEMO.T1.C1","DBDEMO.T2.C2"],
    "metadata_schema_name" : "TMPUSER",
    "run_type" : "first", 
    "directory_path" : "/tmp",
    "compress_storage_rec_threshold" : 5000, 
    "trace" : 1}'
    );
commit;    
end;
/
pause
clear screen
--
-- @securefile_migration_script.sql
--
-- (normally is silent, echo'd here)
--
pause
@securefile_migration_script_new.sql
pause
clear screen
desc tmpuser.SF_MIGRATION_BASICFILE_MIGRATION_REPORT;
clear screen
col TABLE_NAME  format a10                            
col COLUMN_NAME format a10                            
col BASICFILE   format a10                            
col INTERIM_TABLE format a10                          
col MIGRATION_RESULT  format a12                      

select
   table_name       
  ,interim_table    
  ,migration_result 
from tmpuser.sf_migration_basicfile_migration_report;
pause
clear screen
conn sys/admin@db23 as sysdba
update migration_config
set data = json_transform(data,set '$.run_type' = 'second');
commit;
pause
--
-- @securefile_migration_script.sql
--
-- (normally is silent, echo'd here)
--
pause
@securefile_migration_script_new.sql
pause
clear screen
select
   table_name       
  ,interim_table    
  ,migration_result 
from tmpuser.sf_migration_basicfile_migration_report;
pause
clear screen
conn dbdemo/dbdemo@db23
set long 5000
select dbms_metadata.get_ddl('TABLE','T1');
pause
select * from t1;

pause Done

