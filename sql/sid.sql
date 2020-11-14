col username format a20
col module format a20 trunc
set verify off
undefine process
select s.sid, s.serial#, s.USERNAME, s.module, s.sql_id, s.program
from v$session s, v$process p
where s.PADDR = p.ADDR
and ( p.SPID = nvl(to_number('&&process'),p.SPID)
  or s.process = nvl('&&process',s.process) );
  