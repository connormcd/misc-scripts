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
  case when s.username is null then to_char(null) 
       when s.username = 'IMS' then
          case when s.osuser like 'PD%' then 'os:'||s.osuser 
               when module is not null then substr(trim(module),1,10)||' '||substr(action,1,8)
               when action is not null then substr(action,1,8)
               else s.username
          end
       when s.username = 'IMSWAPS' then
          case when s.osuser like 'PD%' then 'os:'||s.osuser 
               when module is not null then module
               when action is not null then action
               else s.username
          end
       else
          s.username
  end username, s.last_call_et, 
       decode(s.lockwait, null, s.status, 'BLOCKED') status, s.sql_id, 
  case when s.program is not null then s.program
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end program, 
     s.event, s.seconds_in_wait
from v$session s
where s.sid = nvl(to_number('&sid'),s.sid)
and ( s.status in ('ACTIVE','KILLED') 
      or s.last_call_et <= 5 
     )
and ( s.username is not null or ( s.username is null and s.last_call_et < 300 ) )
);



