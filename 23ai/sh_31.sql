clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
undefine pdb
col namex new_value pdb
select name namex from v$pdbs where rownum = 1;
drop user local_dba cascade;
set termout on
set echo off
clear screen
prompt |
prompt |  _    ___     ______  _____  _____ _____      _____  ______          _____      ____  _   _ _  __     __
prompt | | |  | \ \   / /  _ \|  __ \|_   _|  __ \    |  __ \|  ____|   /\   |  __ \    / __ \| \ | | | \ \   / /
prompt | | |__| |\ \_/ /| |_) | |__) | | | | |  | |   | |__) | |__     /  \  | |  | |  | |  | |  \| | |  \ \_/ / 
prompt | |  __  | \   / |  _ <|  _  /  | | | |  | |   |  _  /|  __|   / /\ \ | |  | |  | |  | | . ` | |   \   /  
prompt | | |  | |  | |  | |_) | | \ \ _| |_| |__| |   | | \ \| |____ / ____ \| |__| |  | |__| | |\  | |____| |   
prompt | |_|  |_|  |_|  |____/|_|  \_\_____|_____/    |_|  \_\______/_/    \_\_____/    \____/|_| \_|______|_|   
prompt |
pause
clear screen
set echo on
conn sys/admin@db23 as sysdba
pause
create user local_dba identified by local_dba;
pause
grant dba to local_dba;
pause
alter pluggable database &&pdb close immediate;
pause
alter pluggable database &&pdb open hybrid read only;
pause
clear screen
conn scott/tiger@db23
pause
delete from emp;
pause

clear screen
conn local_dba/local_dba@db23
pause
delete from scott.emp;
pause

clear screen
conn system/admin@db23
pause
delete from scott.emp;
pause
rollback;
pause
clear screen
conn sys/admin@db23 as sysdba
pause
alter pluggable database &&pdb open read write;
pause
alter pluggable database &&pdb close immediate;
alter pluggable database &&pdb open read write;

pause Done
