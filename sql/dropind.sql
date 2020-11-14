set pages 0
set heading off
spool /tmp/xxx.sql
select 'alter table '||table_name||' drop constraint '||constraint_name||';'
from user_constraints
where constraint_type = 'P';
spool off
@/tmp/xxx.sql
spool /tmp/xxx.sql
select distinct 'drop index '||index_name||';'
from user_indexes;
spool off
@/tmp/xxx
!rm -f /tmp/xxx.sql
PROMPT Count of indexes = 
select count(*) from user_indexes;
