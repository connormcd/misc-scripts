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
select text
from user_source
where name like nvl(upper('&name'),name)||'%'
order by name, type, line;
