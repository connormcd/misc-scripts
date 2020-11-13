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

set verify off
col username format a32
select * from v$session s where s.sid = to_number('&1')
@pr

undef 1
undef 2
undef 3
