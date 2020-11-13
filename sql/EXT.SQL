-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
PROMPT I=index, T=table
set verify off
col segment_name format a40
select segment_name, segment_type, extents
from user_segments
where segment_type = decode(upper('&type'),'I','INDEX','T','TABLE',segment_type)
order by extents;
