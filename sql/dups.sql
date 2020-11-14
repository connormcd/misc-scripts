set verify off
set pages 2000
select &&column_name, count(*)
from &table_name
group by &&column_name
having count(*) >1;
undefine column_name
undefine table_name
