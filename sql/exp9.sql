col id format 999
col pid format 999
col plan format a80
set lines 500
set long 5000
undefine parms 
accept parms char prompt 'parms '
SELECT * 
--from table(dbms_xplan.display('sys.plan_table$','&id',nvl2('&&parms','typical &&parms','typical')))
from table(dbms_xplan.display('PLAN_TABLE','&id',nvl2('&&parms','typical &&parms','typical')));
set lines 100
