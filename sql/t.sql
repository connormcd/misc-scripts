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
drop table t purge;
create table t as select * from dba_objects where object_id is not null;
set echo off
