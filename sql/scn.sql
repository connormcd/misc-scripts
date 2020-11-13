-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set serverout on
exec dbms_output.put_line(dbms_flashback.GET_SYSTEM_CHANGE_NUMBER);
