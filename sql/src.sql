set verify off
select text
from user_source
where name like nvl(upper('&name'),name)||'%'
order by name, type, line;
