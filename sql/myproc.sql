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
select s.USERNAME, p.pid, p.SPID, s.serial#, s.sql_address
from v$session s, v$process p
where s.PADDR = p.ADDR
and s.SID = ( select sid from v$mystat where rownum = 1 );

