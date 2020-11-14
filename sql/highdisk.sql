select disk_reads / ( select sum(disk_reads) from v$sqlarea where parsing_schema_id > 0 ), sql_text
from v$sqlarea
where disk_reads > 50000
order by 1;
