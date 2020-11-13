-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set timing on
select count(*) from 
( select rownum from dual connect by level <= 20000 ),
( select rownum from dual connect by level <= 30000 )
/


