set pages 0
set heading off
spool /tmp/recomp2.sql
select 'alter '||decode(object_type,'PACKAGE BODY','package',object_type)||
       ' '||object_name||' compile'||decode(object_type,'PACKAGE BODY',' body;',';')
from user_objects
where status != 'VALID'
order by decode(object_type,'VIEW',10,'TRIGGER',99,'PACKAGE',1,'PACKAGE BODY',40,60);
spool off
@/tmp/recomp2.sql
spool off
