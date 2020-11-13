-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
set verify off
select synonym_name, table_owner, table_name
from dba_synonyms
where synonym_name like '%'||upper('&1')||'%';
