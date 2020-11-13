-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select 'alter table '||TABLE_NAME||' deallocate unused keep '||
(round(NUM_ROWS*AVG_ROW_LEN*1.5/1024)+64)||'k;'
from user_tables;
