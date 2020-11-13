-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine table_name_req
undefine owner_req
col low_val for a32
col high_val for a32
col data_type for a12
set lines 200

select
   a.column_name,
   display_raw(a.low_value,b.data_type) as low_val,
   display_raw(a.high_value,b.data_type) as high_val,
   b.data_type,
   a.num_distinct
from
   dba_tab_col_statistics a, 
   dba_tab_cols b
where
   a.table_name=upper('&&table_name_req') and
   a.table_name=b.table_name and
   a.owner = upper('&&owner_req') and
   b.owner = a.owner and
   a.column_name=b.column_name
/
