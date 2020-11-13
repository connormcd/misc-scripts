-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set serveroutput on size 999999
declare
  n varchar2(100);
  b varchar2(32767);
  cursor t is select trigger_name, trigger_body from user_triggers;
begin
open t;
loop
  fetch t into n,b;
  exit when t%notfound;
  if instr(upper(b),upper('&srchfor')) > 0 then
    dbms_output.put_line(n);
  end if;
end loop;
end;
/
