-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set verify off
col name format a50
set lines 100
select st.sid, s.name, st.value
from v$statname s, v$sesstat st 
where st.STATISTIC# = s.STATISTIC#
and s.name like '%'||'&stat_prefix'||'%';
