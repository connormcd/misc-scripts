-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set termout off
col p1 new_value 1
col p2 new_value 2
col p3 new_value 3
select null p1, null p2, null p3 from dual where  1=2;
set termout on

select sid, client_info from v$session where client_info is not null
and sid = nvl('&1',sid);

undef 1
undef 2
undef 3
