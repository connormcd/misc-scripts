-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col owner format a15
col COLUMN_NAME format a30
col LOW_VALUE format a12 trunc
col high_value format a12 trunc
set lines 150
set long 30
set verify off
select OWNER, COLUMN_NAME,NUM_DISTINCT,AVG_COL_LEN, num_nulls, density,
    ( select decode(count(*),0,to_number(null),count(*)) from all_tab_histograms
      where owner = all_tab_cols.owner
      and   table_name = all_tab_cols.table_name
      and   column_name = all_tab_cols.column_name ) hist_cnt,
      case when column_name like 'SYS_%C%$' or VIRTUAL_COLUMN = 'YES' then data_default else null end fbi
from all_tab_cols
where      table_name = upper('&table_name_req')
and ( owner not like 'TAB%' or owner in ( 'TABTCMC','TABREP'))
order by owner, table_name,COLUMN_ID;
