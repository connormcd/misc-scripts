-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col COLUMN_NAME format a30
col LOW_VALUE format a12 trunc
col high_value format a12 trunc
set lines 120
set long 30
set verify off
select COLUMN_NAME,NUM_DISTINCT,AVG_COL_LEN, num_nulls, density,
    ( select decode(count(*),0,to_number(null),count(*)) from all_tab_histograms
      where owner = user
      and   table_name = all_tab_cols.table_name
      and   column_name = all_tab_cols.column_name ) hist_cnt,
      case when column_name like 'SYS_%C%$' then data_default else null end fbi
from all_tab_cols
where      table_name = upper('&table_name_req')
and owner = user
order by owner, table_name,COLUMN_ID;
