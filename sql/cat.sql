select view_name
from dba_views
where view_name like upper('DBA%&&1%')
and owner = 'SYS'
union all
select view_name
from v$fixed_view_definition
where view_name like upper('%&&1%')
order by 1;

undefine 1
