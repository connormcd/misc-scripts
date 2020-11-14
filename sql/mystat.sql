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
col name format a60
set lines 100
select s.name, st.value
from v$statname s, v$mystat st 
where st.STATISTIC# = s.STATISTIC#
and s.name like '%'||nvl('&statname',name)||'%';
