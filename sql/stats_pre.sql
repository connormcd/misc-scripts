-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
drop table stats_pre;
create table stats_pre pctfree 0 as
select statistic#, value
from  v$mystat;
