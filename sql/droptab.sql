set pages 0
set heading off
spool /tmp/xxx.sql
select distinct 'drop table '||table_name||' cascade constraints;'
from user_tables;
spool off
@/tmp/xxx
!rm -f /tmp/xxx.sql
PROMPT Count of Tables = 
select count(*) from user_tables;
