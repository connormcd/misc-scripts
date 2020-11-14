-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set pages 999
set verify off
spool /tmp/analyze.sql
select 'analyze table '||table_name||' '||nvl('&analyze_type','estimate')||
       ' statistics &additional_clauses;'
from user_tables
where 	table_name like nvl(upper('&table_name'),table_name)||'%'
and ( last_analyzed is null 
   or last_analyzed > sysdate - nvl('&days_since_last',2000) );
spool off
@/tmp/analyze
