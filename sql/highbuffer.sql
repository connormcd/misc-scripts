-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select buffer_gets/ ( select sum(buffer_gets) from v$sqlarea where parsing_schema_id > 0 ), sql_text
from v$sqlarea
where buffer_gets > 200000
order by 1;
