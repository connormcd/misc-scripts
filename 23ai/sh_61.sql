clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set long 5000
clear screen
set termout on
set echo off
prompt |  
prompt |  
prompt |    __  __ ______ _______       _____       _______       
prompt |   |  \/  |  ____|__   __|/\   |  __ \   /\|__   __|/\    
prompt |   | \  / | |__     | |  /  \  | |  | | /  \  | |  /  \   
prompt |   | |\/| |  __|    | | / /\ \ | |  | |/ /\ \ | | / /\ \  
prompt |   | |  | | |____   | |/ ____ \| |__| / ____ \| |/ ____ \ 
prompt |   |_|  |_|______|  |_/_/    \_\_____/_/    \_\_/_/    \_\
prompt |                                                          
prompt |  
set echo on
set timing on
pause
select DBMS_METADATA.GET_DDL('TABLE','EMP','SCOTT')
from dual;
pause
clear screen
select DBMS_DEVELOPER.GET_METADATA('EMP','SCOTT','TABLE','BASIC') 
from dual

pause
/

pause Done
