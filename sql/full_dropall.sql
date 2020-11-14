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
select distinct 'drop '||object_type||' '||owner||'.'||object_name||';'
from dba_objects
where object_type not in ('INDEX','PACKAGE BODY','TRIGGER')
and object_type = 'TABLE'
and owner not like 'SYS%'
order by 1 desc;
spool off
@/tmp/xxx
!rm -f /tmp/xxx.sql
