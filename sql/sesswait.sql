undefine sid
select seq#, event, wait_time_micro, time_since_last_wait_micro
from v$session_wait_history
where sid = &sid;

