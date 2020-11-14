set heading off
set linesize 80
set feedback off
spool tmp.sql
select distinct 
'prompt Update Cascade on table: ' || table_name || 
chr(10) ||
'execute update_cascade.on_table( ''' || table_name || ''' )' 
from user_constraints
where constraint_type = 'P'
and constraint_name in
( select r_constraint_name
  from user_constraints
  where constraint_type = 'R' )
/
spool off
set heading on
set feedback on
