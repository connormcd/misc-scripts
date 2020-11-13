-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col segment_name format a40
col segment_type format a16
set verify off
select segment_name, segment_type, extents, bytes
from user_segments
where segment_name like upper(nvl('&segment_name',segment_name))||'%';
