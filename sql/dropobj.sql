-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select 'drop table '||table_name||' cascade constraints;'
from user_tables
union
select 'drop '||object_type||' '||object_name||';'
from user_objects
where object_type in ('PROCEDURE','FUNCTION','VIEW','PACKAGE','SNAPSHOT')
