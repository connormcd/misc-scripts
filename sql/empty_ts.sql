-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set autotrace off
set verify off
undefine tspace
select 'drop '||object_type||' '||owner||'.'||object_name||case when object_type = 'TABLE' then ' cascade constraints purge' end||';'
from  dba_objects
where object_type in ('TABLE','INDEX')
and owner not in ('SYS','SYSTEM')
and object_name in ( select distinct segment_name from dba_segments where tablespace_name = upper('&1') );

set verify on

