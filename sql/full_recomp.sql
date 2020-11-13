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
spool /tmp/xxx.sql
select 'PROMPT '||owner||'.'||object_name||chr(10)||'alter '||decode(object_type,'PACKAGE BODY','package',object_type)||' '||owner||'.'||object_name||' compile'||decode(object_type,'PACKAGE BODY',' body;',';')
from dba_objects
where status != 'VALID';
spool off
spool /tmp/xxx
@/tmp/xxx.sql
spool off
