select sql_hash_value hash_value
from v$session
where sid in
( select sid
  from v$session_wait
  where event = 'db file scattered read'
  and wait_time = 0
)
/
