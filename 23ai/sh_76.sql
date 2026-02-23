clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
clear screen
set termout on
set echo off
set serverout on
prompt |   
prompt |     _____       _______ ______ _____ _____ ______ ______ 
prompt |    |  __ \   /\|__   __|  ____|  __ \_   _|  ____|  ____|
prompt |    | |  | | /  \  | |  | |__  | |  | || | | |__  | |__   
prompt |    | |  | |/ /\ \ | |  |  __| | |  | || | |  __| |  __|  
prompt |    | |__| / ____ \| |  | |____| |__| || |_| |    | |     
prompt |    |_____/_/    \_\_|  |______|_____/_____|_|    |_|     
prompt |                                                          
prompt |                                                          
prompt |   
pause
clear screen
set echo on
clear screen
select sysdate date1, sysdate-1000 date2 ;
pause
with t as ( select sysdate date1, sysdate-1000 date2 )
select date2 - date1 days
from t;
pause
with t as ( select sysdate date1, sysdate-1000 date2 )
select months_between(date1,date2) months
from t;
pause
clear screen
with t as ( select sysdate date1, sysdate-1000 date2 )
select (date2-date1)/365 years_maybe
from t;
pause
with t as ( select sysdate date1, sysdate-1000 date2 )
select trunc(months_between(date1,date2))/12 years_maybe
from t;
pause
clear screen
with t as ( select localtimestamp date1, localtimestamp-numtodsinterval(1000,'DAY') date2 )
select date2 - date1 days
from t;
pause
with t as ( select localtimestamp date1, localtimestamp-numtodsinterval(1000,'DAY') date2 )
select extract(DAY from date2 - date1) days
from t;
pause
with t as ( select localtimestamp date1, localtimestamp-numtodsinterval(1000,'DAY') date2 )
select extract(YEAR from date2 - date1) days
from t;
pause
clear screen
select DATEDIFF(year,sysdate-1000,sysdate) yr;
pause
select DATEDIFF(month,sysdate-1000,sysdate) mth;
pause
select DATEDIFF(second,sysdate-1000,sysdate) secs;
pause
select DATEDIFF(microsecond,systimestamp-numtodsinterval(3.5,'SECOND'),systimestamp) us;
pause Done
