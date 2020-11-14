-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set verify off
set lines 130

accept tspace char prompt 'Tablespace Name :- '

break on file_id skip 1

ttitle center 'Tablespace Map for ' &tspace -
       skip 2

select file_id, block_id, blocks, owner, bytes, segment_name, segment_type
from dba_extents
where tablespace_name = upper('&tspace')
union
select file_id, block_id, blocks, '==FREE==', bytes, '==FREE==', '==FREE=='
from dba_free_space
where tablespace_name = upper('&tspace')
order by 1, 2
/
