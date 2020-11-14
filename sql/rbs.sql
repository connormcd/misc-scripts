-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col SEGMENT_NAME format a10 trunc
col TABLESPACE_NAME format a12 trunc
select SEGMENT_NAME, TABLESPACE_NAME, INITIAL_EXTENT, NEXT_EXTENT, MIN_EXTENTS, MAX_EXTENTS, STATUS
from dba_rollback_segs;
col SEGMENT_NAME format a30 trunc
