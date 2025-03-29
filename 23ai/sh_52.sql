--
--
-- DEFER
--

conn sys/admin@db23 as sysdba
grant execute on dbms_redefinition to dbdemo;

conn dbdemo/dbdemo@db23

drop user tmpuser cascade;
@drop t1
@drop t2
@drop T1_INT1
@drop T2_INT2

create table t1 ( x int primary key, c1 clob ) lob ( c1) store as basicfile ;
create table t2 ( x int primary key, c2 clob ) lob ( c2) store as basicfile ;

insert into t1
select rownum, rpad('x',1000)
connect by level <= 100;

insert into t2
select rownum, rpad('x',1000)
connect by level <= 100;

commit;

conn sys/admin@db23 as sysdba
drop table sys.migration_config purge;
create table migration_config (ctime date, data clob , constraint c1 check(data is json));
create user tmpuser;
alter user tmpuser quota 200m on users;

begin
delete migration_config ;
insert into migration_config values
    (systimestamp,
    '{"schema_name" : ["DBDEMO"],
    "table_name" : ["DBDEMO.T1", "DBDEMO.TG2"],
    "column_name" : ["DBDEMO.T1.C1","DBDEMO.T1.C2"],
    "metadata_schema_name" : "TMPUSER",
    "run_type" : "first", 
    "directory_path" : "/tmp",
    "compress_storage_rec_threshold" : 5000, 
    "trace" : 1}'
    );
end;
/
select * from migration_config;

@securefile_migration_script.sql

desc tmpuser.report3;

col TABLE_NAME  format a10                            
col COLUMN_NAME format a10                            
col BASICFILE   format a10                            
col INTERIM_TABLE format a10                          
col ALLOW_MIGRATE format a12                          
col MIGRATION_RESULT  format a12                      

select 
table_name
,column_name
,basicfile
,interim_table
,allow_migrate
,migration_result
from tmpuser.report3;

update migration_config
set data = json_transform(data,set '$.run_type' = 'second');

commit;

conn dbdemo/dbdemo@db23

create table T1_INT1 ( x int primary key, c1 clob ) lob ( c1) store as securefile ;
create table T2_INT2 ( x int primary key, c2 clob ) lob ( c2) store as securefile ;

conn sys/admin@db23 as sysdba

pause Done
