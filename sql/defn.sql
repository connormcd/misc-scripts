-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine otyp
undefine own

col object_type new_value otyp
col owner new_value own

select object_type, owner 
from (
select object_type, owner from dba_Objects
where object_name = upper('&1')
order by 
  decode(owner,user,1,2),
  decode(object_type,'TABLE',1,'VIEW',2,3)
)
where rownum = 1;

set long 500000
select dbms_metadata.get_ddl('&otyp',upper('&1'),'&own') from dual;

undefine otyp
undefine own
undefine 1