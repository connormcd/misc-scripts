-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col tot_free format a20
col alloc_size format a20

select d.tablespace_name, lpad(round(tot_size/1024/1024)||'m',10) alloc_size, lpad(round(f.tot_free/1024/1024)||'m',10) tot_free, round(100-100*tot_free/tot_size) pct_used
from
( select tablespace_name, sum(tot_free) tot_free 
  from
  ( select tablespace_name, sum(bytes) tot_free
    from dba_free_space
    group by tablespace_name
    union all
    select tablespace_name, 0
    from dba_data_files
    group by tablespace_name 
    union all
    select tablespace_name, 0 
    from dba_temp_files
    group by tablespace_name 
    union all
    select s.tablespace, -1*alloc*t.block_size 
    from ( select /*+ NO_MERGE */ tablespace, sum(blocks) alloc
           from   v$sort_usage 
           group by tablespace) s, 
          dba_tablespaces t
    where t.tablespace_name = s.tablespace
  )
  group by tablespace_name
) f,
( select tablespace_name, sum(bytes) tot_size
  from dba_data_files
  group by tablespace_name 
  union all
  select tablespace_name, sum(bytes) 
  from dba_temp_files
  group by tablespace_name 
) d
where d.tablespace_name like nvl(upper('&tablespace_prefix'),d.tablespace_name)||'%'
and f.tablespace_name(+) = d.tablespace_name
order by 1;
