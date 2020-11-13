-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine sid
select seq#, event, wait_time_micro, time_since_last_wait_micro
from v$session_wait_history
where sid = &sid;

