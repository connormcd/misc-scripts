-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine trc
undefine prf
col value new_value trc
col value1 new_value prf

select value, replace(value,'.trc','.prf') value1
from v$diag_info
where name = 'Default Trace File';

host C:\oracle\product\12.2.0.1\bin\tkprof &&trc &&prf

