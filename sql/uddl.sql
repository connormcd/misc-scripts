-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set long 100000
set longchunksize 100000
select dbms_metadata.get_ddl('USER',upper('&1')) from dual;
