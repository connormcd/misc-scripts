-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select view_name
from sys.v_$fixed_view_definition
where view_name like '%'||upper('&partial_name')||'%'
order by 1;
