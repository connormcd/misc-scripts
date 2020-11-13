-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set verify off
select s.USERNAME, s.program, s.machine, sa.sql_text, sa.executions
from v$session s, v$process p, v$sqlarea sa
where s.PADDR = p.ADDR
and sa.address = s.sql_address
and p.SPID = &process;
