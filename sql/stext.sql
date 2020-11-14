-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set verify off
set long 32767
select sql_fulltext
from v$sql -- v$sqltext
where sql_id = ( select sql_id
from v$session
where sid = '&sid'
)
/

