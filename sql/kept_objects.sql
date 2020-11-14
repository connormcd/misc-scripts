select OWNER, NAME, TYPE, SHARABLE_MEM, LOADS, EXECUTIONS, LOCKS, PINS
from v$db_object_cache
where KEPT = 'YES'
/
