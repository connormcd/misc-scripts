-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select b.inst_id, b.sid, b.serial#,b.username,b.machine ,b.status,b.prev_sql_id,c.sql_text,d.object_id,e.object_name,
a.start_time,to_char(b.logon_time,’MM/DD/YY HH24:MI:SS’) logon_time
from    gv$transaction a ,
gv$session b ,
gv$sql c,
v$locked_object d,
all_objects e
where a.inst_id = b.inst_id
and a.ses_addr = b.SADDR
and b.prev_sql_addr = c.address(+)
and b.prev_hash_value = c.hash_value(+)
and b.prev_child_number = c.child_number(+)
and b.inst_id = c.inst_id(+)
and b.prev_sql_id=c.sql_id
and d.object_id=e.object_id
and d.session_id=b.sid(+)
/
