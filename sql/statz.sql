undefine sid

set verify off
col name format a50
set lines 100
select 
  --st.sid, 
  decode('&&sid','my',s.STATISTIC#,st.sid) sid_stat#,
s.name, st.value
from v$statname s, v$sesstat st 
where st.STATISTIC# = s.STATISTIC#
and st.sid = nvl(to_number(
decode('&&sid','my',sys_context('USERENV','SID'),'','','&&sid')
),st.SID)
and s.name like '%'||nvl('&stat_prefix',s.name)||'%'
and st.value != 0;

undefine sid
