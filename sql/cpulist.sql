-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select s.USERNAME, p.SPID
from v$session s, v$process p
where s.PADDR = p.ADDR;
