-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col object_name format a40
col owner format a12
set lines 100
set verify off
select owner, object_name, object_type, status, created
from dba_objects
where object_name like upper(nvl('&object_name',object_name))||'%'
and object_type like upper(nvl('&object_type',object_type))||'%';
