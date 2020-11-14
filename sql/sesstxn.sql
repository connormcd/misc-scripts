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
col username format a32
col tid format a16
select /*+ leading(t s) */ t.XIDUSN||'.'||t.XIDSLOT||'.'||XIDSQN tid,
     s.sid, s.serial#, 
          s.username
  || ' ('||s.last_call_et||')' username,
  case when s.lockwait is null then
          s.status
  else 'BLOCKED'
  end status, 
  s.sql_id sql_id, 
  case when s.program is not null then s.program
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end || '-' || s.osuser program , 
       blocking_session,
       t.used_urec
from v$session s, v$transaction t
where s.saddr = t.SES_ADDR
order by s.sid;


