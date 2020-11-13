-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select tablespace_name, round(sum(bytes)/1024/1024,1) "TOT_FREE (MB)", 
             round(max(bytes)/1024/1024,1) "LARGEST_SEGMENT (MB)"
from sys.dba_free_space
where tablespace_name like nvl(upper('&tablespace_prefix'),tablespace_name)||'%'
group by tablespace_name;
