-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine minutes
@longdate
select cast(CREATION_TIMESTAMP as date) tim, count(*)
from fixedodds.transaction
where CREATION_TIMESTAMP > sysdate - numtodsinterval(nvl('&&minutes',5)*60,'SECOND')
group by cast(CREATION_TIMESTAMP as date)
order by 1
/
undefine minutes
