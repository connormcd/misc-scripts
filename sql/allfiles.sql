-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select name from v$controlfile
union all
select name from v$datafile
union all
select member from v$logfile
union all
select name from v$tempfile;
