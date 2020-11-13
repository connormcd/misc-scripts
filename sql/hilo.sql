-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
-- ===================================
-- = Example query using display_raw =
-- ===================================
col low_val for a32
col high_val for a32
col data_type for a32

select
   a.column_name,
   display_raw(a.low_value,b.data_type) as low_val,
   display_raw(a.high_value,b.data_type) as high_val,
   b.data_type
from
   all_tab_col_statistics a, 
   all_tab_cols b
where
   a.table_name=upper('&table_name_req') and
   a.table_name=b.table_name and
   a.column_name=b.column_name and 
   ( a.owner not like 'TAB%' or a.owner = 'TABTCMC')
order by a.owner, a.table_name,b.COLUMN_ID;
