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
set long 5000
select * from table(dbms_xplan.display_cursor('&sql_id',nvl('&child',0),'ALLSTATS LAST'));        
set lines 100
