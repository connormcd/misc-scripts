col event format a40 trunc
select event, sum(total_waits), sum(time_waited)
from v$session_event
where sid > 9
group by event
order by 3;


