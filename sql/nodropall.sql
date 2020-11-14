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
spool /tmp/xxx.sql
select 'drop table '||table_name||' cascade constraints;'
from user_tables
union all
select 'drop '||object_type||' '||object_name||';'
from user_objects
where object_type not in ('TABLE','INDEX','PACKAGE BODY','TRIGGER')
order by 1;
spool off
PROMPT cf: /tmp/xxx.sql
