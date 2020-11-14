-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
create or replace view sys.rwwa_lock_contention as
SELECT  /*+ ORDERED */
        substr(decode(substr(upper(s.action),1,2),'PD',s.action,s.osuser),1,12) osuser,
        S.SID,
        L.TYPE,
        L.ID1,
        substr(o.name,1,22) name,
        DECODE(L.LMODE, 0, 'NONE', 1, 'NULL', 2, 'SS', 3, 'RX', 4, 'S', 5, 'SRX', 6, 'X', '?') holding,
        DECODE(L.REQUEST, 0, 'NONE', 1, 'NULL', 2, 'SS', 3, 'RX', 4, 'S', 5, 'SRX', 6, 'X', '?') wanting,
        l.ctime how_long,
        decode(l.block,0,null,2,null,'YES') is_blocking
FROM V$SESSION S, V$LOCK L, sys.obj$ o
WHERE L.SID=S.SID
AND S.USERNAME is not null
and l.id1 = o.obj#(+)
order by s.sid
/

grant select on sys.rwwa_lock_contention to public;

create or replace
public synonym rwwa_lock_contention for sys.rwwa_lock_contention;
