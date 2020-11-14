set	wrap off
set linesize 100
set	feedback off
set	pagesize 0
set	verify off
set termout off

spool /tmp/ytmpy.sql


prompt prompt LOAD DATA
prompt prompt INFILE *
prompt prompt INTO TABLE &1 
prompt prompt REPLACE
prompt prompt FIELDS TERMINATED BY '|'
prompt prompt (
select  'prompt ' || decode(column_id,1,'',',') || lower(column_name)
from    user_tab_columns
where   table_name = upper('&1')
order by column_id
/
prompt prompt )
prompt prompt BEGINDATA

prompt  select
select  lower(column_name)||'||chr(124)||'
from    user_tab_columns
where   table_name = upper('&1') and
    column_id != (select max(column_id) from user_tab_columns where
             table_name = upper('&1'))
			 order by column_id
/
select  lower(column_name)
from    user_tab_columns
where   table_name = upper('&1') and
    column_id = (select max(column_id) from user_tab_columns where
             table_name = upper('&1'))
			 order by column_id
/
prompt  from    &1
prompt  /

spool off
set termout on
@/tmp/ytmpy.sql
