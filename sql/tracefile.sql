--undefine sid
--select lower(d.instance_name) || '_ora_' || ltrim(a.spid) || nvl2(p.value,'_'||p.value,null) || '.trc'
--from v$session b, v$process a, v$instance d, v$parameter p
--where B.SID = &&SID
--and   a.addr = b.paddr
--and   p.name = 'tracefile_identifier'
--/
--undefine sid

select p.TRACEFILE
from v$session s, v$process p
where s.PADDR = p.ADDR
and s.SID = sys_context('USERENV','SID');

