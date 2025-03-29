clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout on
set echo off
prompt | 
prompt | 
prompt |    _____  ____  _          _____  _     _    _  _____ 
prompt |   / ____|/ __ \| |        |  __ \| |   | |  | |/ ____|
prompt |  | (___ | |  | | |        | |__) | |   | |  | | (___  
prompt |   \___ \| |  | | |        |  ___/| |   | |  | |\___ \ 
prompt |   ____) | |__| | |____    | |    | |___| |__| |____) |
prompt |  |_____/ \___\_\______|   |_|    |______\____/|_____/ 
prompt |                                                       
prompt |                                                       
set echo on
select * from non_existent_table;
pause
show errordetails
pause
set errordetails on
pause
select * from non_existent_table;
pause
set errordetails verbose
pause
select * from non_existent_table;
pause
set errordetails off
set echo off
clear screen
prompt SQL> select * from mega_table order by 1;
prompt select * from mega_table order by 1
prompt *
prompt ERROR at line 1:
prompt ORA-04030: out of process memory when trying to allocate 16384 bytes
prompt
prompt SQL> pause
pause
set echo on
oerr ora 4030
pause
help 4030
pause
help ora-4030
pause
clear screen
conn jane/doe@123123
pause
ping 123123
pause
show connection nets
pause
show connection nets db19
pause
ping db23
pause
conn scott/tiger@db23
pause
config export tns

pause Done
