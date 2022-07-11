CREATE OR REPLACE PACKAGE BODY apex_utils.apex_utils_jobs
IS

/******************************************************************************
 * APEX Utility Jobs
 *
 * Utility jobs for the APEX environment 
 *
 * $Activity:$
 * $Source:$
 ******************************************************************************/

g_owner CONSTANT VARCHAR2(30) := 'APEX_UTILS';
g_fqn   VARCHAR2(60);

-- scheduler job name prefixes.  
--  eg
--   MON#SQLPLAN   
g_scheduler_prefix VARCHAR2(4) := 'APEX';
g_scheduler_suffix VARCHAR2(1) := '#';

-- Simple logger.  Be default we pretty much spew everything out to dbms_output
-- and to data_maint_log
PROCEDURE logger (p_msg   IN VARCHAR2
                 ,p_level IN NUMBER  DEFAULT g_log_level) 
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  dbms_application_info.set_client_info(p_msg);
  
  IF BITAND(p_level,1) = 1 THEN
     dbms_output.put_line(p_msg);
  END IF;

  IF BITAND(p_level,2) = 2 THEN
    INSERT INTO maint_log ( maint_seq, tstamp, class, subclass, msg )
    VALUES (maint_seq.NEXTVAL, SYSTIMESTAMP, 'MONITOR', g_fqn, p_msg);
    COMMIT;
  END IF;
END logger;

-- as the name suggests, log an error and then bomb out.  
PROCEDURE die (p_msg IN VARCHAR2)
IS
BEGIN
  logger(p_msg, 3);
  raise_application_error (c_bkup_job_errno, p_msg);
END die;  

-- removes old partitions from an interval partitioned table
PROCEDURE purge_old_partitions (p_table_name     IN  VARCHAR2
                               ,p_interval_days  IN  NUMBER
                               ,p_retention_days IN  NUMBER)
AS
  
   -- a cursor to return the table partitions
   CURSOR table_partition_cur (p_table_name IN VARCHAR2)
   IS
   SELECT partition_name
   ,      high_value
   ,      high_value_length
   ,      partition_position
   ,      MAX(partition_position) OVER () AS max_partition_position
   FROM   user_tab_partitions
   WHERE  table_name  = p_table_name
   ORDER  BY
          -- start checking the earliest partitions first
          -- so we can stop once we've reached a partition
          -- that we want to retain
          partition_position;

   l_table_partition_rec table_partition_cur%ROWTYPE;
   l_high_value_char     VARCHAR2(100);
   l_high_value_date     DATE;
   l_finished_processing BOOLEAN := FALSE;

   PROCEDURE set_ddl_timeout
   AS
   BEGIN
      EXECUTE IMMEDIATE 'ALTER SESSION SET ddl_lock_timeout=30';
   END set_ddl_timeout;
  
   -- we move the range partition so we can drop earlier partitions 
   PROCEDURE move_range_partition (p_table_name    IN VARCHAR2
                                  ,p_interval_days IN NUMBER)
   AS
      l_loop_counter NUMBER(1) := 0;
      l_finished     BOOLEAN   := FALSE;
   BEGIN
      -- try 3 times to set the partitioning interval
      -- fail if we still can't do it after 3 tries
      LOOP
         BEGIN
            EXIT WHEN l_finished;
            EXECUTE IMMEDIATE 'alter table ' || p_table_name || ' set interval (NUMTODSINTERVAL(' || TO_CHAR(p_interval_days) || ',''DAY''))';
            l_finished := TRUE;
         EXCEPTION
            WHEN OTHERS THEN
               l_loop_counter := l_loop_counter + 1;
               IF (l_loop_counter > 3) THEN
                  RAISE;
               END IF;
         END;   
      END LOOP;        
   END move_range_partition;
BEGIN
     
   set_ddl_timeout;

   -- move the last range partition
   move_range_partition (p_table_name    => p_table_name
                        ,p_interval_days => p_interval_days);

   -- start looping through the partitions in the table from the first partition
   -- to the last, dropping partitions if they exceed the max retention period
   -- we stop when we find a partition that should not be dropped
   OPEN table_partition_cur (p_table_name);
   LOOP
      FETCH table_partition_cur INTO l_table_partition_rec;
      EXIT WHEN table_partition_cur%NOTFOUND
           -- can't delete the last partition on the table
           OR   l_table_partition_rec.partition_position = l_table_partition_rec.max_partition_position 
           OR   l_finished_processing;
           
      -- extract the partition high value as a VARCHAR2 from that annoying LONG
      l_high_value_char := SUBSTR(l_table_partition_rec.high_value,1,l_table_partition_rec.high_value_length);
           
      -- convert the partiton high value to a DATE datatype
      EXECUTE IMMEDIATE 'SELECT '||l_high_value_char||' FROM dual'
      INTO l_high_value_date;
           
      -- if this partition is older than our retention period we drop it
      IF (l_high_value_date < (TRUNC(SYSDATE) - p_retention_days)) THEN
         logger ('dropping partition for high value '||TO_CHAR(l_high_value_date,'dd/mm/yyyy'));
         EXECUTE IMMEDIATE 'alter table ' || p_table_name || ' drop partition '||l_table_partition_rec.partition_name;
        
      -- if we've hit a partition that we do not need to drop then we can
      -- stop processing the cursor
      ELSE
         l_finished_processing := TRUE;
      END IF;
        
   END LOOP;
     
   CLOSE table_partition_cur;
     
END purge_old_partitions;



PROCEDURE backup_apps (p_action  VARCHAR2 DEFAULT 'DEFAULT')
IS

  c_job_name         CONSTANT VARCHAR2(20) := g_scheduler_prefix||g_scheduler_suffix||'APEXBKUP';
  c_backup_retention CONSTANT NUMBER(5) := 7;
    
  PROCEDURE new_job 
  IS
  BEGIN
    logger('Scheduling APEX application export job');
    dbms_scheduler.create_job (
       job_name           =>  c_job_name,
       job_type           =>  'PLSQL_BLOCK',
       job_action         =>  LOWER(g_owner)||'.apex_utils_jobs.backup_apps;',
       start_date         =>  TRUNC(SYSDATE,'HH') + (15/60/24), -- job commences at at 15 minutes past the hour
       repeat_interval    =>  'FREQ=HOURLY; INTERVAL=1',
       enabled            =>  true,
       comments           =>  'Backup APEX applications');
  END new_job;       

  PROCEDURE process
  IS
--      CURSOR apex_app_cur
--      IS
--      SELECT f.id AS application_id
--      FROM   apex_040200.wwv_flows f
--      ,      apex_040200.wwv_flow_companies w
--      WHERE  w.provisioning_company_id <> 0
--      AND    f.security_group_id       =  w.provisioning_company_id
--      AND    w.display_name  NOT IN ('Unknown'
--                                    ,'INTERNAL'
--                                    ,'COM.ORACLE.APEX.REPOSITORY')
--      AND    ROWNUM = 1                                    
--      ORDER  BY
--             f.id;
      
      CURSOR apex_app_cur
      IS
      SELECT application_id
      ,      workspace
      FROM   apex_applications
      WHERE  workspace NOT IN ('INTERNAL'
                              ,'COM.ORACLE.APEX.REPOSITORY'
                              ,'COM.ORACLE.CUST.REPOSITORY')
      ORDER  BY
             application_id;

      l_app  CLOB;
   BEGIN
      logger ('Executing APEX app backup');
      
      apex_custom_auth.set_user('admin'); 
           
      FOR i IN apex_app_cur
      LOOP
      
         wwv_flow_api.set_security_group_id(apex_util.find_security_group_id(i.workspace));
         --apex_util.set_security_group_id (i.workspace_id);
      
         l_app := wwv_flow_utilities.export_application_to_clob (i.application_id);
      
         INSERT INTO apex_app_backup
            (application_id
            ,backup_time
            ,apex_app)
         VALUES
            (i.application_id
            ,SYSDATE
            ,l_app);
      END LOOP;
      
      purge_old_partitions (p_table_name     => 'APEX_APP_BACKUP'
                           ,p_interval_days  => 1
                           ,p_retention_days => c_backup_retention);
           
   END process;

BEGIN
   g_fqn := c_job_name;
   logger ('APEX app backup, action=' || p_action);

   CASE UPPER(p_action)
      WHEN 'DISABLE'    
      THEN dbms_scheduler.disable (c_job_name);
     
      WHEN 'ENABLE'     
      THEN dbms_scheduler.enable (c_job_name);
     
      WHEN 'UNSCHEDULE' 
      THEN  dbms_scheduler.drop_job (c_job_name, force=>true);
     
      WHEN 'SCHEDULE'   
      THEN new_job;
     
      WHEN 'DEFAULT'    
      THEN  process;
                
      ELSE die ('Unknown action: ' || p_action);
   END CASE;
   
END backup_apps;

END apex_utils_jobs;
/
