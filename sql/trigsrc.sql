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
set long 6000
select trigger_name, trigger_body
from user_triggers
where table_name = upper(nvl('&table_name_req',table_name));
