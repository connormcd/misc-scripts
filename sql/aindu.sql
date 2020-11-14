set verify off
select 	table_name, index_name,distinct_keys, status
from 	all_indexes
where 	table_name like nvl(upper('&table_name'),table_name)||'%'
order by 1,2;
