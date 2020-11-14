set verify off
col username format a32
select s.sid, s.serial#, 
          s.username
  || ' ('||s.last_call_et||')' username,
  case when s.lockwait is null then
          s.status
  else 'BLOCKED'
  end || case when t.XIDUSN is not null then '-XACT' end status,
  s.sql_id sql_id, 
  case when s.program is not null then s.program
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end || '-' || s.osuser program 
from v$session s, 
     v$transaction t
where s.sid = nvl(to_number('&sid'),s.sid)
and s.saddr = t.ses_addr(+)
order by s.sid;

undefine pd
