-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
prompt
prompt RECYCLE candidates
prompt
SELECT obj object
,COUNT(1) buffers
,100*(COUNT(1)/totsize) pct_cache
FROM
sys.x_$bh
,(select value totsize from v$parameter
where name = 'db_block_buffers')
WHERE tch = 1
OR (tch = 0 AND lru_flag < 8)
GROUP BY obj,totsize
HAVING 100*(COUNT(1)/totsize) > 5;


prompt
prompt KEEP candidates
prompt
SELECT obj object
,COUNT(1) buffers
,AVG(tch) avg_touches
FROM
sys.x_$bh
WHERE lru_flag = 8
GROUP BY obj
HAVING AVG(tch) > 5
AND COUNT(1) > 20;
