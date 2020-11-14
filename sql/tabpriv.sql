undefine table_name_req

select grantee, owner, table_name
from dba_tab_privs
where table_name = upper('&1');
