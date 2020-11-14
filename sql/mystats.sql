-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
create or replace
view v_$mystats
as select s.name, m.value
from v$statname s, v$mystat m
where s.statistic# = m.statistic# ;

grant select on v_$mystats to public;

create or replace public synonym v$mystats for v_$mystats;

