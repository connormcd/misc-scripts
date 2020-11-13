-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set termout off
col p1 new_value 1
col p2 new_value 2
col p3 new_value 3
select null p1, null p2, null p3 from dual where  1=2;
set termout on

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
  case when s.program is not null then 
         ( case when s.program like 'oracle%(%)%' then regexp_substr(s.program,'^oracle.*\((.*)\).*$',1, 1, 'i', 1)
                else s.program
                end )
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end || '-' || s.osuser program , 
       blocking_session,
       case 
         when blocking_session is null then cast(null as varchar2(1))
         else 
          cast(( select substr(s1.osuser||'-'||s1.program,1,60)
            from   v$session s1
            where s1.sid = s.blocking_session
          ) as varchar2(60))
       end blocker
from v$session s, 
          ( select sid job_sid
            from   v$lock
            where  type = 'JQ' ) j
where s.sid = nvl(to_number('&1'),s.sid)
and s.sid = j.job_sid(+)
order by s.sid;

undef 1
undef 2
undef 3
