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
select s.sid, s.USERNAME, s.status, s.sql_address, sa.buffer_gets, sa.disk_reads, sa.executions
from v$session s, v$sqlarea sa
where s.sid = nvl(to_number('&sid'),s.sid)
and s.sql_address = sa.address
and s.status = 'ACTIVE';
