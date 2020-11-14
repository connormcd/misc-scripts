set verify off
select 	table_name, NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,CHAIN_CNT
from 	user_tables
where 	table_name like nvl(upper('&table_name'),table_name)||'%'
order by 1;