-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
TOTAL POOL

select u.name||'.'||nvl(o.subname,o.name) segname,
       decode(o.type#, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      39, 'LOB PARTITION', 40, 'LOB SUBPARTITION',
                     'UNDEFINED')
  ,COUNT(1) buffers
  ,sum(tch) touches
from sys.obj$ o, sys.user$ u, sys.x_$bh x
where o.owner# = u.user#
and u.user# != 0
and o.dataobj# = x.obj
and o.type# in (1,2,3,19,20,21,34,35,39,40)
GROUP BY u.name||'.'||nvl(o.subname,o.name),
       decode(o.type#, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      39, 'LOB PARTITION', 40, 'LOB SUBPARTITION',
                     'UNDEFINED')
order by 3


RECYCLE pool

select u.name||'.'||nvl(o.subname,o.name) segname,
       decode(o.type#, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      39, 'LOB PARTITION', 40, 'LOB SUBPARTITION',
                     'UNDEFINED')
  ,COUNT(1) buffers
  ,100*(COUNT(1)/totsize) pct_cache
from sys.obj$ o, sys.user$ u, sys.x_$bh x,
    (select value totsize from v$parameter where name = 'db_block_buffers')
where o.owner# = u.user#
and o.dataobj# = x.obj
and ( tch = 1 OR (tch = 0 AND lru_flag < 8) )
and o.type# in (1,2,3,19,20,21,34,35,39,40)
GROUP BY u.name||'.'||nvl(o.subname,o.name), totsize, 
       decode(o.type#, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      39, 'LOB PARTITION', 40, 'LOB SUBPARTITION',
                     'UNDEFINED')
HAVING 100*(COUNT(1)/totsize) > 5;


select u.name||'.'||nvl(o.subname,o.name) segname,
       decode(o.type#, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      39, 'LOB PARTITION', 40, 'LOB SUBPARTITION',
                     'UNDEFINED')
  ,COUNT(1) buffers
  ,AVG(tch) avg_touches
from sys.obj$ o, sys.user$ u, sys.x_$bh x
where o.owner# = u.user#
and o.dataobj# = x.obj
and lru_flag = 8
and o.type# in (1,2,3,19,20,21,34,35,39,40)
GROUP BY u.name||'.'||nvl(o.subname,o.name),
       decode(o.type#, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      39, 'LOB PARTITION', 40, 'LOB SUBPARTITION',
                     'UNDEFINED')

HAVING AVG(tch) > 5
AND COUNT(1) > 20;


