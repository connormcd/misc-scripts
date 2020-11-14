-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
declare
  j number := &job;
  s varchar2(100);
begin
  select schema_user into s from dba_jobs
  where job = j;

  execute immediate 
    'create procedure '||s||'.tmp$remjob is begin dbms_job.remove('||j||'); end;';

  execute immediate 
    'begin '||s||'.tmp$remjob; end;';

  execute immediate 
    'drop procedure '||s||'.tmp$remjob';

end;
/

