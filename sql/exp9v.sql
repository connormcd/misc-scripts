col id format 999
col pid format 999
col plan format a80
set lines 120
set long 5000
col l new_value id
select hash_value||'-'||child_number l
from  v$sql
where address = '&sql_address'
and rownum = 1;
exec dbms_application_info.set_client_info('&&sql_address')
SELECT * 
from table(dbms_xplan.display('v$plan_table','&id'));
