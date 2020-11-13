-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
SELECT  substr(S.USERNAME,1,16) username,
        S.SID,
        L.TYPE,
        L.ID1,
        substr(o.object_name,1,22) name,
        DECODE(L.LMODE, 0, 'NONE', 1, 'NULL', 2, 'SS', 3, 'RX', 
           4, 'S', 5, 'SRX', 6, 'X', '?') mode1,
        DECODE(L.REQUEST, 0, 'NONE', 1, 'NULL', 2, 'SS', 3, 
           'RX', 4, 'S', 5, 'SRX', 6, 'X', '?') req,
        l.ctime,
        decode(l.block,0,null,'TRUE') block
FROM V$LOCK L, V$SESSION S, dba_objects o
WHERE L.SID=S.SID
AND S.USERNAME is not null
and l.id1 = o.object_id (+)
order by s.sid
