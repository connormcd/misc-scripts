-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine sid

set verify off
set pages 9999
col name format a80
set lines 130
select 
  --st.sid, 
  decode('&&sid','my',s.STATISTIC#,st.sid) sid_stat#,
s.name, st.value
from v$statname s, v$sesstat st 
where st.STATISTIC# = s.STATISTIC#
and st.sid = nvl(to_number(
decode('&&sid','my',sys_context('USERENV','SID'),'','','&&sid')
),st.SID)
and s.name like '%'||nvl('&stat_prefix',s.name)||'%';

undefine sid
