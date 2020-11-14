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
undefine tot
variable tot number
begin
select count(*) into :tot from dba_objects
where status != 'VALID';
end;
/
spool /tmp/www.sql
select 'PROMPT '||rownum||' of '||:tot||chr(10)||
       'alter '||decode(object_type,'PACKAGE BODY','package',object_type)||
       ' '||owner||'.'||object_name||' compile'||decode(object_type,'PACKAGE BODY',' body;',';')
from ( select * from dba_objects
       where status != 'VALID' 
       order by decode(owner,'SYS',1,2), 
            decode(object_type,'VIEW',10,'TRIGGER',99,'PACKAGE',1,'PACKAGE BODY',40,60) 
     );
spool off
@/tmp/www.sql
