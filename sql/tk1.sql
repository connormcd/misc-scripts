-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
undefine prf
col value1 new_value prf

select replace('&&1','.trc','.prf') value1 from dual;

host C:\oracle\product\12.2.0.1\bin\tkprof &&1 &&prf

host "C:\Program Files\TextPad 8\TextPad.exe" &&prf
