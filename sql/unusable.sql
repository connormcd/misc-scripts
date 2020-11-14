set pages 999
select index_name, partition_name
from dba_ind_partitions
where status = 'UNUSABLE'
union all
select index_name, subpartition_name
from dba_ind_subpartitions
where status = 'UNUSABLE'
union all
select index_name, null
from dba_indexes
where status = 'UNUSABLE'
order by 1
/
