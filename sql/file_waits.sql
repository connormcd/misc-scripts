-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col name format a40
select name, count
from sys.x_$kcbfwait, v$datafile
where indx + 1 = file#;
