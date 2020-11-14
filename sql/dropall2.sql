set pages 0
set lines 300
set heading off
spool /tmp/qwe123a.sql
select 'drop table '||table_name||' cascade constraints;'
from user_tables
union all
select 'drop '||object_type||' '||object_name||';'
from user_objects
where object_type not in ('TABLE','INDEX','PACKAGE BODY','TRIGGER')
order by 1;
spool off
@/tmp/qwe123a
PROMPT Count of Objects = 
select object_type,count(*) from user_objects group by object_type;
