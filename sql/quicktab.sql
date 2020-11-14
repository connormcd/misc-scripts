-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
drop table &&1 cascade constraints purge;
create table &&1
as select d.* from dba_objects d,
  ( select 1 from dual connect by level <= &&2 );
  
create index &&1._ix on &&1 ( object_id );
