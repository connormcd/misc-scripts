-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col name format a16
set lines 200
set feedback on
select name, password
from  sys.user$
where name like upper(nvl('&username',name))||'%'
order by 1;
