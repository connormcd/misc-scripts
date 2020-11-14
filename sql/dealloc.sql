select 'alter table '||TABLE_NAME||' deallocate unused keep '||
(round(NUM_ROWS*AVG_ROW_LEN*1.5/1024)+64)||'k;'
from user_tables;
