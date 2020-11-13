-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set ver off pages 50000 lines 160 tab off
undef event_name
undef days_history
undef interval_hours
def event_name="&1"
def days_history="&2"
def interval_hours="&3"
col time for a19
col EVENT_NAME for a64
col total_waits for 99999999999999
col total_time_s for 999999999.999
col avg_time_ms for 999999999.999
select to_char(time,'DD.MM.YYYY HH24:MI:SS') time, instance_number inst, event_name, sum(delta_total_waits) total_waits, round(sum(delta_time_waited/1000000),3) total_time_s, round(sum(delta_time_waited)/decode(sum(delta_total_waits),0,null,sum(delta_total_waits))/1000,3) avg_time_ms from
    (select hse.snap_id, hse.instance_number,
      trunc(sysdate-&days_history+1)+trunc((cast(hs.begin_interval_time as date)-(trunc(sysdate-&days_history+1)))*24/(&interval_hours))*(&interval_hours)/24 time,
      EVENT_NAME,
      (lead(TOTAL_WAITS,1) over(partition by hs.STARTUP_TIME, hs.instance_number, EVENT_NAME order by hse.snap_id))-TOTAL_WAITS delta_total_waits,
      (lead(TIME_WAITED_MICRO,1) over(partition by hs.STARTUP_TIME, hs.instance_number, EVENT_NAME order by hse.snap_id))-TIME_WAITED_MICRO delta_time_waited
   from DBA_HIST_SYSTEM_EVENT hse, DBA_HIST_SNAPSHOT hs
   where hse.snap_id=hs.snap_id
      and hse.instance_number = hs.instance_number
      and hs.begin_interval_time>=trunc(sysdate)-&days_history+1
      and hse.EVENT_NAME like '&event_name')
group by time, event_name, instance_number
order by 2, 1;