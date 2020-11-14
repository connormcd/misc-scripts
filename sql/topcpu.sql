set verify off
set lines 200
undefine secs
col username format a45
col status format a20
with top_ash as 
( select /*+ MATERIALIZE */ session_id, cpu
from (
  select session_id, count(*) cpu
  from v$active_session_history
  where session_state = 'ON CPU'
  and sample_time > sysdate - nvl(to_number('&&secs'),60)/86400
  group by session_id
  order by 2 desc
)
where rownum <= 10
)
select sid, 
       serial#, 
       username ||
          case 
            when event = 'Streams AQ: waiting for messages in the queue' then 
               ' (queue=' || to_char(seconds_in_wait)||','||to_char(last_call_et) 
                ||')' 
            else
              ' ('||to_char(last_call_et)||')'
            end username, 
       status||' (cpu='||cpu||')' status,
       sql_id,
       program
from (
select s.sid, s.serial#, s.username,
       s.last_call_et, 
       decode(s.lockwait, null, s.status, 'BLOCKED') status, s.sql_id, 
       top_ash.cpu,
  case when s.program is not null then s.program
       when s.username is null then ( select p.program
                                      from   v$process p
                                      where  s.PADDR = p.ADDR )
       end program, 
     s.event, s.seconds_in_wait
from v$session s, top_ash
where s.sid = top_ash.session_id
)
/
undefine secs
