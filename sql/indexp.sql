col table_name format a30
col index_name format a30
col column_name format a30
set lines 120
set verify off
select 	*
from 	all_ind_expressions
where 	table_name like nvl(upper('&table_name'),table_name)||'%'
and	index_name like nvl(upper('&index_name'),index_name)||'%'
and index_owner != 'POL_AUDIT'
order by table_name,index_name,column_position;
