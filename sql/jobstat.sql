-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select job, failures, to_char(last_date,'DD/MM HH24:MI') last_date, what
from dba_jobs;