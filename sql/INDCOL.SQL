-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col table_name format a30
col index_name format a30
col column_name format a30
set lines 120
set verify off
select  table_name, index_name,column_name
from  all_ind_columns
where   table_name like nvl(upper('&table_name'),table_name)||'%'
and index_name like nvl(upper('&index_name'),index_name)||'%'
order by table_name,index_name,column_position;
