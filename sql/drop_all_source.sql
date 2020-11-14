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
set lines 300
set heading off
spool /tmp/qwe123.sql
select 'drop '||object_type||' '||owner||'.'||object_name||';'
from dba_objects
where owner in ('TOTE','ACCT','ITSP','PSUM','TRAN')
and object_type in ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
order by 1;
spool off
@/tmp/qwe123
