-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
accept username char prompt 'User ? '
select username, default_tablespace, temporary_tablespace,created
from dba_users
where username like upper(nvl('&username',username))||'%';

pro Sys privs

select *
from dba_sys_privs
where grantee like upper(nvl('&username',grantee))||'%'
order by grantee;

pro Role privs

select *
from dba_role_privs
where grantee like upper(nvl('&username',grantee))||'%'
order by grantee;

pro Synonyms

select owner, table_owner, count(*)
from dba_synonyms
where owner like upper(nvl('&username',owner))||'%'
group by owner, table_owner;

undefine username
