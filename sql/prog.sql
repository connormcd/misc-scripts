-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select o.object_name, s.PROGRAM_LINE#
from   dba_objects o, v$sql s
where  s.sql_id = '&1'
and    s.program_id = o.object_id;
