UNDEFINE USERNAME

set verify off
col username format a32
select s.sid, s.serial#, 
          s.username
  || ' ('||s.last_call_et||')' username,
  case when s.lockwait is null then
       case when s.username is null then
          nvl2(j.job_sid,'ACTIVE','INACTIVE')
       else
          s.status
       end     
  else 'BLOCKED'
  end status, 
  s.sql_id sql_id, 
  case when s.program is not null then s.program
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end || '-' || s.osuser program , 
       blocking_session
from v$session s, 
          ( select sid job_sid
            from   v$lock
            where  type = 'JQ' ) j
where ( upper('&&username') in (upper(s.osuser),s.username) or nvl('&&username','x') = 'x' )
and s.sid = j.job_sid(+)
order by nvl2('&&username',lpad(s.sid,10),s.username);


