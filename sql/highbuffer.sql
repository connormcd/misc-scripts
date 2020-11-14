select buffer_gets/ ( select sum(buffer_gets) from v$sqlarea where parsing_schema_id > 0 ), sql_text
from v$sqlarea
where buffer_gets > 200000
order by 1;
