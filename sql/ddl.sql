-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine object_name
undefine owner

set long 100000
set longchunksize 100000
col x new_value typ
col y new_value own
select owner y, object_type x
from dba_objects
where object_name = upper('&&object_name')
and  owner = nvl(upper('&&owner'),owner)
and object_type not like '%PARTITION%' 
and object_type not like '%SYNONYM%' 
and owner != 'PUBLIC'
and rownum = 1;

select dbms_metadata.get_ddl(upper('&typ'),upper('&&object_name'),upper('&&owner')) from dual;
