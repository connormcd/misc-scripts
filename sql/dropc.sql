-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set autotrace off
set verify off
undefine x1
undefine y1
undefine x2
undefine y2
col y1 new_value x1
col y2 new_value x2
select substr(nvl(max(case when object_type = 'MATERIALIZED VIEW' then 'ZMATERIALIZED VIEW' else 'A'||object_type end),'atable'),2) y1, 
       decode(nvl(max(case when object_type = 'MATERIALIZED VIEW' then 'ZMATERIALIZED VIEW' else 'A'||object_type end),'ATABLE'),'ATABLE','cascade constraints purge') y2
from user_objects
where lower(object_name) = lower('&1')
and object_type in ('VIEW','TABLE','FUNCTION','PROCEDURE','SEQUENCE','PACKAGE','MATERIALIZED VIEW','TYPE','INDEX');

drop &&x1 &1 &&x2;
set verify on
clear screen
