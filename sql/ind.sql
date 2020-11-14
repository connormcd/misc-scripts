col index_name format a30
set lines 140
set verify off
select  table_name, index_name,distinct_keys, num_rows, clustering_factor, 
   case when status = 'UNUSABLE' then 'UNUS,' end ||
   case when VISIBILITY = 'INVISIBLE' then 'INVIS,' end misc
from 	user_indexes
where 	table_name like nvl(upper('&table_name'),table_name)||'%'
order by 1,2;
