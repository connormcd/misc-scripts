with snapdbtime 
as 
( select sn.snap_id
, sn.instance_number as inst_num
,round(sn.startup_time,'MI') startup_time
,round(sb.begin_interval_time,'MI') as begin_Time
,round(sb.end_interval_time,'MI') as end_Time
,tm.value / 1000000 as dbtime_secs
from
  dba_hist_snapshot sn
  ,dba_hist_sys_time_model
where sn.dbid = tm.dbid
and sn.instance_number = tm.instance_number
and sn.snap_id = tm.snap_id
and tm.stat_name = 'DB time'
),
deltadbtime as 
( select 
select snap_id
, inst_num
,startup_time
,end_Time
,dbtime_secs
,lag(dbtime_secs,1) over ( partition by inst_num, startup_time order by snap_id asc) as begin_dbtime
,case when begin_time = startup_time then dbtime_secs
 else
   dbtime_secs - lag(dbtime_secs,1) over ( partition by inst_num, startup_time order by snap_id asc)
 end as dbtime_secs_delta
 ,(end_time-begin_time)*24*60*60 as elapsed_secs
 from snapdbtime
 order by inst_num, snap_id asc
 )
 select inst_num
 ,snap_id
 ,round(dbtime_secs,1) as dbtime_secs
 ,round(dbtime_secs_delta / elapsed_secs,3) as avgactive
 from deltadbtime
 /
from