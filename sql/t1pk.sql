set echo on
drop table t1 purge;
create table t1 as select * from dba_objects where object_id is not null;
alter table t1 add constraint t1_pk primary key ( object_id ) ;
set echo off
