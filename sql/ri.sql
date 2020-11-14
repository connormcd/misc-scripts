set pages 0
set heading off
spool /tmp/xxx.sql
select 'alter table '||table_name||' enable constraint '||constraint_name||';'
from user_constraints
where constraint_type = 'R';
spool off
@/tmp/xxx.sql
!rm -f /tmp/xxx.sql
