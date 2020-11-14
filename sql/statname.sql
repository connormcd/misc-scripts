set verify off
col name format a70
set lines 100
select s.STATISTIC#, s.name
from v$statname s
where s.name like '%'||nvl('&1',s.name)||'%';
