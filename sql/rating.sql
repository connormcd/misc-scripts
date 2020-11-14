select
  s.SID,
decode(s.username,null,to_char(null),
             decode(s.USERNAME,'IMS',nvl2(module||action,action||','||module,'IMS'), s.username)) username,    
     st.value "CPU Used",
   round(st.value / ( sysdate - s.logon_time),2) rating,
   decode(s.LOCKWAIT,null,'No','Yes') "Locked?"
from v$session s, v$process p, v$sesstat st
where s.username is not null
and  s.PADDR = p.ADDR
and  s.sid = st.sid
and  st.STATISTIC# = 12
order by rating
