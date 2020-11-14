undefine sortkey
accept sortkey char prompt "Elapsed|CPU|IO ?"
set termout off
col x new_value choice
select 
  case 
    when upper(x) like 'E%' then 'elapsed_time_delta'
    when upper(x) like 'C%' then 'cpu_time_delta'
    when upper(x) like 'I%' then 'iowait_delta'
    else 'elapsed_time_delta'
  end x
from dual;

set termout on

col module format a30 trunc
set lines 200
col sql_text format a60 wrap

WITH sqt
     AS (SELECT elap,
                cput,
                exec,
                iowt,
                sql_id,
                module,action,
                rnum
           FROM (SELECT sql_id,
                        module,action,
                        elap,
                        cput,
                        exec,
                        iowt,
                        ROWNUM rnum
                   FROM (  SELECT sql_id,
                                  MAX (module) module,max(action) action,
                                  SUM (elapsed_time_delta) elap,
                                  SUM (cpu_time_delta) cput,
                                  SUM (executions_delta) exec,
                                  SUM (iowait_delta) iowt
                             FROM dba_hist_sqlstat
                            WHERE     dbid = ( select dbid from v$database)
                                  AND instance_number =  USERENV('Instance')
                                  AND snap_id > (
                                            select max(snap_id) x from dba_hist_snapshot
                                            where dbid = ( select dbid from v$database)
                                            and   instance_number = USERENV('Instance')
                                            and   snap_id < (select max(snap_id) from dba_hist_snapshot
                                                                                              where dbid = ( select dbid from v$database)
                                                                                              and   instance_number =  USERENV('Instance')
                                                                                              )
                                            )
                                 AND snap_id <= (select max(snap_id) from dba_hist_snapshot
                                                  where dbid = ( select dbid from v$database)
                                                  and   instance_number =  USERENV('Instance')
                                                  )
                         GROUP BY sql_id
                         ORDER BY NVL (SUM (elapsed_time_delta), -1) DESC,sql_id))
          WHERE     rnum <= 30
                )
  SELECT /*+ NO_MERGE(sqt) */
         round(NVL ( (sqt.elap / 1000000), TO_NUMBER (NULL)),2) tot_elapsed,
         sqt.exec executions,
         round(DECODE (sqt.exec,0, TO_NUMBER (NULL),(sqt.elap / sqt.exec / 1000000)),4) elap_per_exec,
         round(DECODE (sqt.elap, 0, TO_NUMBER (NULL), (100 * (sqt.cput / sqt.elap))),2) cpu_pct,
         round(DECODE (sqt.elap, 0, TO_NUMBER (NULL), (100 * (sqt.iowt / sqt.elap))),2) iot_pct,
         sqt.sql_id,
         case when module = 'DBMS_SCHEDULER' then sqt.action else sqt.module end module,
         st.sql_text
    FROM sqt, dba_hist_sqltext st
   WHERE st.sql_id = sqt.sql_id AND st.dbid = ( select dbid from v$instance)
   and st.command_type != 47
ORDER BY sqt.rnum
/
