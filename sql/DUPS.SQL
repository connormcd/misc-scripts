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
set pages 2000
select &&column_name, count(*)
from &table_name
group by &&column_name
having count(*) >1;
undefine column_name
undefine table_name
