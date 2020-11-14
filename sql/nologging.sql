undefine owner

set pages 999
select 'alter table '||owner||'.'||table_name||' logging;'
from dba_tables
where owner = nvl('&&owner',owner)
and logging = 'NO'
union all
select 'alter index '||owner||'.'||index_name||' logging;'
from dba_indexes
where owner = nvl('&&owner',owner)
and logging = 'NO'
union all
select 'alter table '||table_owner||'.'||table_name||' modify partition '||partition_name||' logging;'
from dba_tab_partitions
where table_owner = nvl('&&owner',table_owner)
and logging = 'NO'
union all
select 'alter index '||index_owner||'.'||index_name||' modify partition '||partition_name||' logging;'
from dba_ind_partitions
where index_owner = nvl('&&owner',index_owner)
and logging = 'NO'
union all
select distinct 'alter table '||table_owner||'.'||table_name||' modify partition '||partition_name||' logging;'
from dba_tab_subpartitions
where table_owner = nvl('&&owner',table_owner)
and logging = 'NO'
union all
select distinct 'alter index '||index_owner||'.'||index_name||' modify partition '||partition_name||' logging;'
from dba_ind_subpartitions
where index_owner = nvl('&&owner',index_owner)
and logging = 'NO'
order by 1
/
