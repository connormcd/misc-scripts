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
set verify off
select COLUMN_NAME,NUM_DISTINCT,DENSITY, AVG_COL_LEN, num_nulls,
    ( select count(*) from all_tab_histograms
      where owner = all_tab_columns.owner
      and   table_name = all_tab_columns.table_name
      and   column_name = all_tab_columns.column_name ) hist_cnt
from all_tab_columns
where      table_name = upper('&table_name_req')
order by owner, table_name,COLUMN_ID;
