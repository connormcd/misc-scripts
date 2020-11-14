accept username char prompt 'User ? '

col grantee format a40
select lpad(' ',level*2-2)||grantee grantee, granted_role
from dba_role_privs
connect by  prior granted_role =  grantee
start with grantee = upper('&username')
/

undefine username
