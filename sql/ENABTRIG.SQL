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
set lines 200
spool /tmp/xxx.sql
select 'alter trigger '||trigger_name||' enable;'
from user_triggers;
spool off
@/tmp/xxx.sql
!rm -f /tmp/xxx.sql
