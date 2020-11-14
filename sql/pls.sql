-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col object_name format a40
set verify off
select object_type, object_name
from user_objects
where object_name like nvl(upper('&name'),object_name)||'%'
and object_type in ('PROCEDURE','FUNCTION','PACKAGE')
order by object_name;
