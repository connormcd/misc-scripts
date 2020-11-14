-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select s.sid, s.serial#, s.osuser, s.program, st.mem_max
from v$session s,
(
select sid, value mem_max
from 
  ( select sid, value
    from   v$sesstat
    where  statistic# = 26
    order by value desc )
where rownum < = 10
) st
where st.sid = s.sid
/



select s.sid, s.serial#, s.osuser, s.program, st.mem_max
from v$session s,
(
select sid, value mem_max
from 
  ( select sid, value
    from   v$sesstat
    where  statistic# = 25
    order by value desc )
where rownum < = 10
) st
where st.sid = s.sid
/

