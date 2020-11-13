-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col name form a40 
col gets form 999,999,999 
col misses form 999.99 heading "Miss%"
col spins form 999.99 heading "SpinGet%"
col igets form 999,999,999 
col imisses form 999.99  heading "IMiss%"
 
select name,gets,misses*100/decode(gets,0,1,gets) misses, 
spin_gets*100/decode(misses,0,1,misses) spins, immediate_gets igets 
,immediate_misses*100/decode(immediate_gets,0,1,immediate_gets) imisses 
from v$latch 
where ( gets > 0 or immediate_gets > 0) 
order by gets + immediate_gets 
/ 
