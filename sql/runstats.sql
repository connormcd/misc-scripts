grant select on SYS.V_$STATNAME to demo;
grant select on SYS.V_$MYSTAT to demo;
grant select on SYS.V_$LATCH to demo;
grant select on SYS.V_$TIMER to demo;

create global temporary table demo.run_stats
( runid varchar2(15),
  name varchar2(80),
  value int )
on commit preserve rows;

create or replace view demo.stats
as select 'STAT...' || a.name name, b.value
      from v$statname a, v$mystat b
     where a.statistic# = b.statistic#
    union all
    select 'LATCH.' || name,  gets
      from v$latch
	union all
	select 'STAT...Elapsed Time', hsecs from v$timer;

create or replace package demo.runstats_pkg
as
    procedure rs_start;
    procedure rs_middle;
    procedure rs_stop( p_difference_threshold in number default 0 );
end;
/

create or replace package body demo.runstats_pkg
as

g_start number;
g_run1  number;
g_run2  number;

procedure rs_start
is 
begin
    delete from run_stats;

    insert into run_stats 
    select 'before', stats.* from stats;
        
    g_start := dbms_utility.get_time;
end;

procedure rs_middle
is
begin
    g_run1 := (dbms_utility.get_time-g_start);
 
    insert into run_stats 
    select 'after 1', stats.* from stats;
    g_start := dbms_utility.get_time;

end;

procedure rs_stop(p_difference_threshold in number default 0)
is
begin
    g_run2 := (dbms_utility.get_time-g_start);

    dbms_output.put_line
    ( 'Run1 ran in ' || g_run1 || ' hsecs' );
    dbms_output.put_line
    ( 'Run2 ran in ' || g_run2 || ' hsecs' );
    dbms_output.put_line
    ( 'run 1 ran in ' || round(g_run1/g_run2*100,2) || 
      '% of the time' );
    dbms_output.put_line( chr(9) );

    insert into run_stats 
    select 'after 2', stats.* from stats;

    dbms_output.put_line
    ( rpad( 'Name', 30 ) || lpad( 'Run1', 12 ) || 
      lpad( 'Run2', 12 ) || lpad( 'Diff', 12 ) );

    for x in 
    ( select rpad( a.name, 30 ) || 
             to_char( b.value-a.value, '999,999,999' ) || 
             to_char( c.value-b.value, '999,999,999' ) || 
             to_char( ( (c.value-b.value)-(b.value-a.value)), '999,999,999' ) data
        from run_stats a, run_stats b, run_stats c
       where a.name = b.name
         and b.name = c.name
         and a.runid = 'before'
         and b.runid = 'after 1'
         and c.runid = 'after 2'
         -- and (c.value-a.value) > 0
         and abs( (c.value-b.value) - (b.value-a.value) ) 
               > p_difference_threshold
       order by abs( (c.value-b.value)-(b.value-a.value))
    ) loop
        dbms_output.put_line( x.data );
    end loop;

    dbms_output.put_line( chr(9) );
    dbms_output.put_line
    ( 'Run1 latches total versus runs -- difference and pct' );
    dbms_output.put_line
    ( lpad( 'Run1', 12 ) || lpad( 'Run2', 12 ) || 
      lpad( 'Diff', 12 ) || lpad( 'Pct', 10 ) );

    for x in 
    ( select to_char( run1, '999,999,999' ) ||
             to_char( run2, '999,999,999' ) ||
             to_char( diff, '999,999,999' ) ||
             to_char( round( run1/run2*100,2 ), '99,999.99' ) || '%' data
        from ( select sum(b.value-a.value) run1, sum(c.value-b.value) run2,
                      sum( (c.value-b.value)-(b.value-a.value)) diff
                 from run_stats a, run_stats b, run_stats c
                where a.name = b.name
                  and b.name = c.name
                  and a.runid = 'before'
                  and b.runid = 'after 1'
                  and c.runid = 'after 2'
                  and a.name like 'LATCH%'
                )
    ) loop
        dbms_output.put_line( x.data );
    end loop;
end;

end;
/
