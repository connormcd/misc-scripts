-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
accept owner char prompt 'Owner ? '
accept app char prompt 'App User ? '
select 'create synonym &app..'||object_name||' for &owner..'||object_name||';'
from user_objects
where object_type = 'SEQUENCE'
or object_type in ('TABLE','VIEW')
or object_type in ('PACKAGE','PROCEDURE','FUNCTION');
