-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set	wrap off
set linesize 100
set	feedback off
set	pagesize 0
set	verify off
set termout on

spool ytmpy.sql


prompt  select
select  
 case data_type
 when 'NUMBER'   then 'nvl(lpad('||lower(column_name)||','||(data_precision+2)||'),''-'')'
 when 'VARCHAR2' then 'nvl(rpad('||lower(column_name)||','||data_length||'),''-'')'
 when 'CHAR'     then 'nvl(rpad('||lower(column_name)||','||data_length||'),''-'')'
 when 'DATE'     then 'nvl(to_char('||lower(column_name)||',''ddmmyyyyhh24miss''),''-'')'
 else to_char(1/0) end ||'||'
from    all_tab_columns
where   table_name = upper('&1') and
owner = upper('&2') and
    column_id != (select max(column_id) from all_tab_columns where
             table_name = upper('&1') and owner = upper('&2'))
order by column_id
/

select  
 case data_type
 when 'NUMBER'   then 'nvl(lpad('||lower(column_name)||','||(data_precision+2)||'),''-'')'
 when 'VARCHAR2' then 'nvl(rpad('||lower(column_name)||','||data_length||'),''-'')'
 when 'CHAR'     then 'nvl(rpad('||lower(column_name)||','||data_length||'),''-'')'
 when 'DATE'     then 'nvl(to_char('||lower(column_name)||',''ddmmyyyyhh24miss''),''-'')'
 else to_char(1/0) end 
from    all_tab_columns
where   table_name = upper('&1') and
owner = upper('&2') and
    column_id = (select max(column_id) from all_tab_columns where
             table_name = upper('&1')  and owner = upper('&2') )
			 order by column_id
/
prompt  from    &1
prompt  /

spool off
set termout on

