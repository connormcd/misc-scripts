col event format a60 trunc
set lines 120
select event, total_waits, time_waited
from v$system_event
order by 3
/
