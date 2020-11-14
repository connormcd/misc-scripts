select s.USERNAME, p.SPID
from v$session s, v$process p
where s.PADDR = p.ADDR;
