col job_name format a30
col job_action format a50

select lpad(to_char(job),10) job_name, what job_action, to_char(next_date,'dd/mm hh24:mi') next_date, failures, 
  decode(broken,'Y','N','Y')
from dba_jobs
order by 2
/
