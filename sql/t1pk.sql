-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set echo on
drop table t1 purge;
create table t1 as select * from dba_objects where object_id is not null;
alter table t1 add constraint t1_pk primary key ( object_id ) ;
set echo off
