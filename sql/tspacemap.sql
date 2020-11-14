set verify off

clear breaks
clear computes

break on file_id skip 1

compute sum of bytes counter on file_id

column counter format 999 heading 'Free'

clear screen
accept TSPACE char prompt 'Tablespace Name :- '

select file_id, block_id, owner, segment_name, segment_type, blocks, bytes, 0 counter
from dba_extents
where tablespace_name = upper('&&TSPACE')
union all
select file_id, block_id, 'Free', '=== Free Space ===', 'Free', blocks, bytes, 1 counter
from dba_free_space
where tablespace_name = upper('&&TSPACE')
order by file_id, block_id
/
