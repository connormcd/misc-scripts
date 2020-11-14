set verify off
select 	table_name, NUM_ROWS,BLOCKS,EMPTY_BLOCKS,AVG_ROW_LEN,last_analyzed
from 	all_tables
where 	table_name like nvl(upper('&table_name'),table_name)||'%'
and ( owner != 'POL_AUDIT' and owner not like 'TAB%' or owner in ('TABTCMC','TABREP'));
