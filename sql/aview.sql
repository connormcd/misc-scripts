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
select 	view_name
from 	all_views
where 	view_name like nvl(upper('&view_name'),view_name)||'%';
