set termout off
drop table run_stats ;

create global temporary table run_stats
( runid varchar2(15),
  name varchar2(80),
  value int )
on commit preserve rows;

variable g_time number

    delete from run_stats;

set termout on
set feedback on
    insert into run_stats 
    select 'before', stats.* from (
    select 'STAT...' || a.name name, b.value
      from v$statname a, v$mystat b
     where a.statistic# = b.statistic#
    union all
    select 'LATCH.' || name,  gets
      from v$latch
  union all
  select 'STAT...Elapsed Time', hsecs from v$timer
  ) stats;

set feedback off        
exec :g_time := dbms_utility.get_time;

set feedback on

