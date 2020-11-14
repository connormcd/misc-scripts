set verify off
col TRACEFILE format a35 trunc
set lines 200
select s.USERNAME, p.pid, p.SPID, s.serial#, s.sql_address, substr(p.TRACEFILE,-30) tracefile
from v$session s, v$process p
where s.PADDR = p.ADDR
and s.SID = &sid;
