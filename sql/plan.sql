-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col id format 999
col pid format 999
col plan format a80
set lines 500
set long 50000
set longchunksize 1000
undefine sql_id
undefine child
undefine parms 
select child_number, cost from v$sql_plan where sql_id = '&&sql_id' and id = 1;
SELECT *  from table(dbms_xplan.display_cursor('&&sql_id',nvl('&child',(select child_number from v$sql where sql_id = '&&sql_id' and rownum = 1 )
),format=>'ALL &&parms'));
set lines 100
undefine sql_id 
