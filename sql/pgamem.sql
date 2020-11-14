select s.USERNAME, s.module, s.sid, p.PGA_USED_MEM, p.PGA_MAX_MEM
from v$session s, v$process p
where s.PADDR = p.ADDR
and s.username is not null
order by 4
/



