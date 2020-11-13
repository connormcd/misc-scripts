-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set pages 0
set lines 300
set heading off
spool /tmp/qwe123.sql
select 'drop table '||user||'.'||table_name||' cascade constraints purge;'
from user_tables
union all
select 'drop '||object_type||' '||user||'.'||object_name||';'
from user_objects
where object_type not in ('TABLE','INDEX','PACKAGE BODY','TRIGGER','LOB','JOB')
and object_type not like '%LINK%'
and object_type not like '%PARTITION%'
union all
select 'exec dbms_scheduler.drop_job('''||user||'.'||object_name||''',force=>true);'
from user_objects
where object_type = 'JOB'
order by 1;
spool off
@/tmp/qwe123
PROMPT Count of Objects = 
select object_type,count(*) from user_objects group by object_type;
