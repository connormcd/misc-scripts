set verify off
col name format a60
set lines 100
select s.name, st.value
from v$statname s, v$mystat st 
where st.STATISTIC# = s.STATISTIC#
and s.name like '%'||nvl('&statname',name)||'%';
