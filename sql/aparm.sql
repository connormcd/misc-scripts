-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col name format a40
col value format a30
select name, value
from v$parameter
where  lower(name) like '%&1.%'
order by 1;

