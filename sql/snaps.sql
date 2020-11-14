select di.instance_name                                  inst_name
     , s.snap_id                                         snap_id
     , to_char(s.end_interval_time,'dd Mon YYYY HH24:mi') snapdat
     , s.snap_level                                      lvl
  from dba_hist_snapshot s
     , dba_hist_database_instance di
 where s.dbid              = ( select dbid from v$database)
   and di.dbid             = ( select dbid from v$database)
   and s.instance_number   = USERENV('Instance')
   and di.instance_number  = USERENV('Instance')
   and di.dbid             = s.dbid
   and di.instance_number  = s.instance_number
   and di.startup_time     = s.startup_time
   and s.end_interval_time >= sysdate - 12/24
 order by instance_name, snap_id;
 