set pages 999
set verify off
set heading off
set lines 200
undefine o
col owner nopri
col owner new_value o
undefine table_name
accept table_name char prompt 'Table name (required) ? '
spool /tmp/qwe.sql
select owner, 'alter table '||owner||'.'||table_name||' disable constraint '||constraint_name||';'
from dba_constraints
where constraint_type = 'R'
and r_constraint_name in ( 
  select constraint_name
  from dba_constraints
  where table_name = upper('&table_name')
  and constraint_type in ('P','U'));
spool off
@/tmp/qwe.sql
truncate table &&o..&table_name;
host sed "s/ disable / enable /g" /tmp/qwe.sql 
set heading on
undefine table_name
