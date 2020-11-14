select * from v$session_longops
where time_remaining > 0 
/