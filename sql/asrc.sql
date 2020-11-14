set verify off
select text
from dba_source
where name like nvl(upper('&name'),name)||'%'
order by name, type, line;
