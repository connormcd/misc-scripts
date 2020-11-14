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
select distinct 'drop '||object_type||' '||object_name||';'
from user_objects
where object_type not in ('INDEX','PACKAGE BODY','TRIGGER')
order by 1 desc;
spool off
REM @/tmp/xxx
REM !rm -f /tmp/xxx.sql
PROMPT Count of Objects = 
select count(*) from user_objects;
