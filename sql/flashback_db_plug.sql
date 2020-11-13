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
alter session set container = pdb2;
alter pluggable database close abort;
flashback pluggable database to restore point &1;
alter pluggable database open resetlogs;
exit
