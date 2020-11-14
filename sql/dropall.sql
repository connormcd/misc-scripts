undefine owner

set pages 0
set lines 300
set heading off
spool /tmp/qwe123.sql
select 'drop table '||owner||'.'||table_name||' cascade constraints purge;'
from dba_tables
where owner = upper('&&owner')
union all
select 'drop '||object_type||' '||owner||'.'||object_name||';'
from dba_objects
where object_type not in ('TABLE','INDEX','PACKAGE BODY','TRIGGER','LOB','JOB')
and object_type not like '%LINK%'
and object_type not like '%PARTITION%'
and owner = upper('&&owner')
union all
select 'exec dbms_scheduler.drop_job('''||owner||'.'||object_name||''',force=>true);'
from dba_objects
where object_type = 'JOB'
and owner = upper('&&owner')
order by 1;
spool off
@/tmp/qwe123
PROMPT Count of Objects = 
select object_type,count(*) from dba_objects where owner = upper('&&owner') group by object_type;
