-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select distinct regexp_replace(program,'\(.*') pgm, terminal from v$session
where terminal is not null
order by 2,1;