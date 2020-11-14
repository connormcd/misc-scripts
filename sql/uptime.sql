-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select to_char(min(logon_time),'DD/MM/YYYY HH24:MI:SS') started,
  round(sysdate-min(logon_time),2) days
 from v$session;