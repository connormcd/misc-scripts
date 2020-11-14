col tablespace_name format a20
col pct_free format 999.99
select tablespace_name,max_blocks,count_blocks,sum_free_blocks,
100*sum_free_blocks/sum_alloc_blocks pct_free
from ( select tablespace_name, sum(blocks) sum_alloc_blocks 
     from dba_data_files group by tablespace_name ),
    ( select tablespace_name fs_ts_name, max(blocks) max_blocks,
      count(blocks) count_blocks, sum(blocks) sum_free_blocks
      from dba_free_space
      group by tablespace_name )
where tablespace_name = fs_ts_name;
