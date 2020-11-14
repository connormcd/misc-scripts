col table_name format a30
col index_name format a30
set lines 120
set verify off
select 	table_name, constraint_name,column_name
from 	user_cons_columns
where   table_name like nvl(upper('&table_name')||'%',table_name)
and     constraint_name like nvl(upper('&constraint_name')||'%',constraint_name)
order by table_name,constraint_name,position;
