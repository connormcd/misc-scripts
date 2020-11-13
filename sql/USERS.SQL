-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col username format a25
col default_tablespace format a16
col temporary_tablespace format a16
set lines 200
set verify off
select username, default_tablespace, temporary_tablespace,account_status, profile, user_id
from dba_users
where username like upper(nvl('&username',username))||'%'
order by 1;
