clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set define off
undefine 1
host ( echo select '^&1' from dual; > myscript.sql )
clear screen
set define '&'
set verify off
set termout on
set echo off
prompt |
prompt |             _____   _____ _    _ __  __ ______ _   _ _______ 
prompt |       /\   |  __ \ / ____| |  | |  \/  |  ____| \ | |__   __|
prompt |      /  \  | |__) | |  __| |  | | \  / | |__  |  \| |  | |   
prompt |     / /\ \ |  _  /| | |_ | |  | | |\/| |  __| | . ` |  | |   
prompt |    / ____ \| | \ \| |__| | |__| | |  | | |____| |\  |  | |   
prompt |   /_/    \_\_|  \_\\_____|\____/|_|  |_|______|_| \_|  |_|   
prompt |                                                              
prompt |
pause
set echo on
clear screen
host cat myscript.sql
pause
@myscript.sql hello
pause
undefine 1
pause
@myscript.sql 
pause
undefine 1
set define off
host ( echo select nvl^('^&1','default'^) from dual; > myscript.sql )
set define '&'
clear screen
host cat myscript.sql
pause
@myscript.sql 
pause
undefine 1
set define off
host ( echo argument 1 default 'default' > myscript.sql )
host ( echo select '^&1' from dual; >> myscript.sql )
set define '&'
clear screen
host cat myscript.sql
pause
@myscript.sql provided
pause
undefine 1
pause
@myscript.sql 
pause
set define off
host ( echo argument 1 prompt 'please enter a value for param 1^: ' default 'default' > myscript.sql )
host ( echo select '^&1' from dual; >> myscript.sql )
set define '&'
clear screen
host cat myscript.sql
pause
@myscript.sql 


pause Done
