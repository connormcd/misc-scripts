clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
@drop json_store
@drop nba_data
clear screen
set termout on
set echo off
prompt | 
prompt |   ______           _______     __     _      ____          _____  
prompt |  |  ____|   /\    / ____\ \   / /    | |    / __ \   /\   |  __ \ 
prompt |  | |__     /  \  | (___  \ \_/ /     | |   | |  | | /  \  | |  | |
prompt |  |  __|   / /\ \  \___ \  \   /      | |   | |  | |/ /\ \ | |  | |
prompt |  | |____ / ____ \ ____) |  | |       | |___| |__| / ____ \| |__| |
prompt |  |______/_/    \_\_____/   |_|       |______\____/_/    \_\_____/ 
prompt |                                                                   
prompt |                                                                   
pause
set echo on
create or replace
directory JSONDOCS as '/home/oracle/json';
pause
create table json_store (js json)
organization external
  (type oracle_bigdata
   access parameters (com.oracle.bigdata.fileformat = jsondoc)
   location (JSONDOCS:'data.json'))
reject limit unlimited;
pause
create table nba_data
as select * from json_store;
pause
select * 
from nba_data

pause
/

pause Done
