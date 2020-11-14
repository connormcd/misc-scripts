undefine sid
accept sid prompt 'Sid required: '

col event format a44
select 
 session_state
,EVENT
,case when session_state = 'ON CPU' then cpu_time else wait_time end
from (
select 
 session_state
,EVENT
,sum(time_waited)/1000000 wait_time
,count(case when session_state = 'ON CPU' then 1 end ) cpu_time
from v$active_session_history
where session_id = &&sid
and session_serial# = ( select serial# from v$session where sid = &&sid )
and sample_time > 
  ( select sysdate - last_call_et/86400
    from   v$session
    where  sid = &&sid
    and status = 'ACTIVE'
   )
group by  session_state
,EVENT  
order by 3
)
/
undefine sid
