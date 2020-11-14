-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
exec sys.dbms_system.set_ev(&1,&2,10046,nvl('&3',12),'');
select nvl(TRACEFILE,
  '/u01/app/oracle/diag/rdbms/'||
  lower(regexp_replace(sys.database_name,'\..*'))||'/'||
  sys_context('USERENV','INSTANCE_NAME')||'/trace/'||
  sys_context('USERENV','INSTANCE_NAME')||'_ora_'||p.spid||'.trc'
  )
from v$session s, v$process p where s.PADDR = p.ADDR and s.SID =&1;

