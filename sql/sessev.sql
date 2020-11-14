-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine sid
accept sid prompt 'Sid (Default=this session): '

col event format a44
select EVENT
,TOTAL_WAITS
,TOTAL_TIMEOUTS
,SECS
,rpad(to_char(100 * ratio_to_report(secs) over (), 'FM00.00') || '%',8)  pct
,max_wait
from (
select EVENT
,TOTAL_WAITS
,TOTAL_TIMEOUTS
,TIME_WAITED/100 SECS
,max_wait
from v$session_event
where sid = nvl(to_number('&sid'), ( select sys_context('USERENV','SID') from dual ))
and event not like 'SQL*Net%'
union all
select 'CPU', null, null, value/100 , 0 from v$sesstat 
where statistic# = ( select statistic# from v$statname where name = 'CPU used by this session') 
and sid = nvl(to_number('&sid'), ( select sys_context('USERENV','SID') from dual ))
order by 4
)
/
undefine sid
