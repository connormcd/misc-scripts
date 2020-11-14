select job, failures, to_char(last_date,'DD/MM HH24:MI') last_date, what
from dba_jobs;