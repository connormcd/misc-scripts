-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
REM select 'alter session set events '||''''||'immediate trace name coalesce level '||to_char(ts#)||''''||';' from sys.ts$
REM where name = upper('&ts_name_required');
set verify off
alter tablespace &ts_name_required coalesce;
