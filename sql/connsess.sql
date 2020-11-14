col username format a32
select username, count(*) sess_count, min(last_call_et), max(case when status = 'ACTIVE' then 'ACTIVE' end) status
from   v$session
where username is not null
group by username
order by 1;
