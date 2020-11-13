-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select * 
from table(dbms_xplan.display(format=>'PARTITION  -COST -BYTES'));
