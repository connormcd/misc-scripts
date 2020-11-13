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
from dba_views
where view_name like upper('%&&1%')
and owner = 'SYS'
union all
select view_name
from v$fixed_view_definition
where view_name like upper('%&&1%')
order by 1;

undefine 1
