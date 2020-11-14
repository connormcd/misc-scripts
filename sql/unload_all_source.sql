set pages 0
set lines 5000
set trimspool on
set arraysize 100
select decode(line,1,'/'||chr(10)||'alter session set current_schema = '||owner||';'||chr(10)||'create or replace '||text,text)
from dba_source
where owner in ('TOTE','ACCT','ITSP','PSUM','TRAN')
and type in ('PACKAGE','PACKAGE BODY','PROCEDURE','FUNCTION')
order by decode(name,'DEBUG_INFO',1,'MSG',1,2),
  owner, name, decode(type,'PACKAGE BODY',2,1), line

spool x:\tmp\plsql.sql
/
spool off
