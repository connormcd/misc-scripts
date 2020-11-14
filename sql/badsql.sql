col sql_text format a64
set lines 200
col who format a22 trunc
select sql_text, buffer_gets,  executions, sql_id, elapsed_time
from v$sqlstats
where buffer_gets > 1000000
order by 2;
set lines 120