-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set feedback off

set serverout on
exec :g_time := dbms_utility.get_time - :g_time;


exec dbms_output.put_line('Elapsed '||(:g_time/100));

    insert into run_stats 
    select 'after', stats.* from (
    select 'STAT...' || a.name name, b.value
      from v$statname a, v$mystat b
     where a.statistic# = b.statistic#
    union all
    select 'LATCH.' || name,  gets
      from v$latch
  union all
  select 'STAT...Elapsed Time', hsecs from v$timer
  ) stats;

exec     dbms_output.put_line( rpad( 'Name', 50 ) || lpad( 'Val', 12 ) );

select rpad( a.name, 50 ) || 
             to_char( b.value-a.value, '999,999,999' ) data
        from run_stats a, run_stats b
       where a.name = b.name
         and a.runid = 'before'
         and b.runid = 'after'
         and abs( b.value-a.value) > 1
       order by a.name;

commit;

set feedback on
