col obj format a40 trunc
col osuser format a12
select /*+ leading(t s l d u) */ to_char(start_date,'DD/MM HH24:MI:SS') dt, s.sid, s.serial#, s.status, l.ctime, s.username, s.osuser, u.name||'.'||d.name obj, t.used_urec, to_char(sysdate-last_call_et/86400,'DD/MM HH24:MI:SS') stopped
from   v$transaction t,
       v$session s,
       v$lock l,
       sys.obj$ d,
       sys.user$ u
where t.ses_addr = s.saddr
and s.sid = l.sid
and l.type = 'TM'
and l.id1 = d.obj#
and d.owner# = u.user#
/

