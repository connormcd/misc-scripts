-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set pages 0
set heading off
col owner format a20
col object_name format a30
col object_type format a20
select object_type, owner, object_name
from dba_objects
where status != 'VALID'
and object_type != 'SYNONYM'
order by owner, object_type, object_name;
