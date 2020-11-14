set pages 0
set heading off
spool /tmp/yyy.sql
select 'alter '||decode(object_type,'PACKAGE BODY','package',object_type)||
       ' '||owner||'.'||object_name||' compile'||decode(object_type,'PACKAGE BODY',' body;',';')
from dba_objects
where status != 'VALID' 
and object_type != 'SYNONYM'
order by decode(owner,'SYS',1,2), 
  decode(object_type,'VIEW',10,'TRIGGER',99,'PACKAGE',1,'PACKAGE BODY',40,60);
spool off
@/tmp/yyy.sql
