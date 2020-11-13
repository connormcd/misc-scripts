-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set echo on
declare
  v_rname varchar2(30);
begin
  select 'RP_'||to_char(sysdate,'YYYYMMDD_HH24MISS') rp into v_rname from dual;
  execute immediate 'CREATE RESTORE POINT '||v_rname||' GUARANTEE FLASHBACK DATABASE';
end;
/
exit
