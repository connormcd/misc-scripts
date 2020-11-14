-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select OWNER, NAME, TYPE, SHARABLE_MEM, LOADS, EXECUTIONS, LOCKS, PINS
from v$db_object_cache
where KEPT = 'YES'
/
