-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set pages 0
set verify off
select s.USERNAME, s.sql_address, s.machine, s.program, sa.sql_text, sa.executions
from v$session s, v$process p, v$sqlarea sa
where s.PADDR = p.ADDR
and p.SPID = nvl(to_number('&process'),p.SPID)
and sa.address = s.sql_address;
