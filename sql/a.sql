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
set lines 200
col username format a45
select sid, 
       serial#, 
--       case when program like '%(J0%' then username else username ||' ('||
--          case when event = 'Streams AQ: waiting for messages in the queue' then 'queue,' end|| to_char(last_call_et) 
--          ||')' end username, 
       username ||
          case 
            when event = 'PL/SQL lock timer' then 
               ' (sleep=' || to_char(seconds_in_wait)||','||to_char(last_call_et) 
                ||')' 
            when event = 'Streams AQ: waiting for messages in the queue' then 
               ' (queue=' || to_char(seconds_in_wait)||','||to_char(last_call_et) 
                ||')' 
            else
              ' ('||to_char(last_call_et)||')'
            end username, 
       status,
       sql_id,
       program
from (
select s.sid, s.serial#, 
  s.username, s.last_call_et, 
       decode(s.lockwait, null, s.status, 'BLOCKED') status, s.sql_id, 
  case when s.program is not null then 
  ( case when s.program like 'oracle%(%)%' then regexp_substr(s.program,'^oracle.*\((.*)\).*$',1, 1, 'i', 1)||
case when s.action is not null then '-'||s.action end  
                else s.program
                end )
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end||case when s.osuser not in ('SYSTEM','oracle') then ':'||s.osuser end program,
     s.event, s.seconds_in_wait
from v$session s
where s.sid = nvl(to_number('&sid'),s.sid)
and ( s.status in ('ACTIVE','KILLED') 
     -- or s.last_call_et <= 1 
     )
and ( s.username is not null or ( s.username is null and s.last_call_et < 300 ) )
);



