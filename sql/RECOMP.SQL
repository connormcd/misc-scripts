-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set pages 0
set heading off
spool /tmp/recomp.sql
select 'alter '||decode(object_type,'PACKAGE BODY','package',object_type)||' '||
       object_name||' compile'||decode(object_type,'PACKAGE BODY',' body','')||';'
from user_objects
where status != 'VALID'
and object_type != 'SYNONYM'
order by decode(object_type,'VIEW',10,'TRIGGER',99,'PACKAGE',1,'PACKAGE BODY',40,60);
spool off
@/tmp/recomp.sql
spool off
