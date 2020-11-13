-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col nm format a20
col id format a10
select 
  sys_context('userenv','instance_name') nm,
  sys_context('userenv','instance') id
from dual;
