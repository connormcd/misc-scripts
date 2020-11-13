-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col COLUMN_NAME format a26
col table_name format a30
set lines 120
set verify off
select table_name, COLUMN_NAME,endpoint_number, endpoint_value
from all_histograms
where   table_name like nvl(upper('&table_name'),table_name)||'%'
and     column_name like nvl(upper('&column_name'),column_name)||'%'
order by 1,2,3;
