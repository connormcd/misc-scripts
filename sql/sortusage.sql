select s.username, s.sid
,su.SQLADDR
,su.SQLHASH
,su.TABLESPACE
,su.SEGTYPE
,su.EXTENTS
,su.BLOCKS
FROM v$session s, v$sort_usage su
WHERE s.saddr=su.session_addr; 
