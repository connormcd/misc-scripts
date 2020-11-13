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
col misc format a12
select  table_name, index_name,distinct_keys, num_rows, clustering_factor, 
   case when status = 'UNUSABLE' then 'UNUS,' end ||
   case when VISIBILITY = 'INVISIBLE' then 'INVIS,' end ||
   case when UNIQUENESS = 'UNIQUE' then 'UNQ,' end ||
   case when PARTITIONED = 'YES' then 'PAR,' end 
   misc
from  all_indexes
where   table_name like nvl(upper('&table_name'),table_name)||'%'
and owner != 'POL_AUDIT'
order by 1,2;
