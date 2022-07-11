CREATE TABLE apex_utils.apex_app_backup
   (application_id   NUMBER    NOT NULL
   ,backup_time      DATE      NOT NULL
   ,apex_app         CLOB)
PARTITION BY RANGE (backup_time) INTERVAL (INTERVAL '1' DAY)
   (PARTITION apex_app_backup_20150101  VALUES LESS THAN (TO_DATE('02/01/2015','dd/mm/yyyy')))
/
