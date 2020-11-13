-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select bp.name, p.pid, p.SPID, s.serial#, s.sql_address
from v$session s, v$process p, v$bgprocess bp
where s.PADDR = p.ADDR
and p.addr = bp.paddr;
