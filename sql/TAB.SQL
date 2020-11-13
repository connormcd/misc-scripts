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
select 	table_name, NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,CHAIN_CNT
from 	user_tables
where 	table_name like nvl(upper('&table_name'),table_name)||'%'
order by 1;