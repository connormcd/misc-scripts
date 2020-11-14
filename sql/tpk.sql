set echo on
drop table t purge;
create table t as select * from dba_objects where object_id is not null;
alter table t add constraint t_pk primary key ( object_id ) ;
set echo off
