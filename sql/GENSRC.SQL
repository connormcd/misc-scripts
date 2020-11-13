-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select 'spool '||decode(object_type,'PACKAGE BODY',object_name||'.plb',object_name||'.pls')||chr(10)||
'select text from user_source where name = '||''''||object_name||''''||chr(10)||
'and object_type = '||''''||object_type||''''||chr(10)||
'order by name, type, line;'||chr(10)||
'spool off'
from user_objects
where object_type in ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
