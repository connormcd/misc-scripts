-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col username format a20
col module format a20 trunc
set verify off
undefine process
select s.sid, s.serial#, s.USERNAME, s.module, s.sql_id, s.program
from v$session s, v$process p
where s.PADDR = p.ADDR
and ( p.SPID = nvl(to_number('&&process'),p.SPID)
  or s.process = nvl('&&process',s.process) );
  