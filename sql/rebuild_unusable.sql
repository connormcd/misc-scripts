-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set pages 999
select 'alter index '||index_owner||'.'||index_name||' rebuild partition '|| partition_name||';'
from dba_ind_partitions
where status = 'UNUSABLE'
union all
select 'alter index '||index_owner||'.'||index_name||' rebuild subpartition '|| subpartition_name||';'
from dba_ind_subpartitions
where status = 'UNUSABLE'
union all
select'alter index '||owner||'.'||index_name||' rebuild ;'
from dba_indexes
where status = 'UNUSABLE'
order by 1
/
