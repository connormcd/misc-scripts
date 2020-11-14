-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
ACCEPT id PROMPT 'Enter ID: '
undefine address

set feedback off
declare
  tcursor integer;
  dummy integer;
  y varchar2(32767);
begin
  select SQL_FULLTEXT
  into y
  from v$sql
  where ( address = '&&address' or sql_id = '&&address' );

  delete from plan_table where statement_id = '&id';
  execute immediate 'explain plan set statement_id = ''&id'' into plan_table for '||y;
end;
/
@exp9
set feedback off
