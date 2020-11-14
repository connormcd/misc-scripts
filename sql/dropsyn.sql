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
set verify off
select  'drop synonym '||owner||'.'||synonym_name||';'
from dba_synonyms
where table_owner = upper(nvl('&table_owner',table_owner))
and owner =  upper(nvl('&owner',owner))

spool /tmp/qweqwe.sql
/
spool off
@/tmp/qweqwe
!rm -f /tmp/qweqwe.sql
