-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set echo on
shutdown immediate
startup mount
flashback database to restore point &1;
alter database open resetlogs;
exit
