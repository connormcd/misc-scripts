set echo on
drop table t purge;
create table t as select * from dba_objects where object_id is not null;
set echo off
