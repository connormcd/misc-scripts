-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col job_name format a40
col job_action format a50
col next_date format a15
col what format a60

select owner||'.'||job_name job_name, 
        case 
          when job_action is not null then job_action
          when program_name is not null then
             ( select 'PGM:'||program_action
               from   dba_scheduler_programs
               where  owner = s.owner
               and    program_name = s.program_name )
        end what, 
        to_char(next_run_date,'dd/mm hh24:mi') next_date, failure_count fail, 
  decode(enabled,'TRUE','Y','N') enabled
from dba_scheduler_jobs s
union all
select lpad(to_char(job),10) job, what, to_char(next_date,'dd/mm hh24:mi') next_date, failures, 
  decode(broken,'Y','N','Y')
from dba_jobs
order by 1
/
