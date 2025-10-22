set termout off
clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
@drop t
clear screen
set termout on
set echo off
set lines 1000
set long 5000
set serverout on
set feedback off
prompt | 
prompt | 
prompt |   __  __ _    _ _____  _____  ______ _____        _____ ______  _____ _____ _____ ____  _   _ 
prompt |  |  \/  | |  | |  __ \|  __ \|  ____|  __ \      / ____|  ____|/ ____/ ____|_   _/ __ \| \ | |
prompt |  | \  / | |  | | |__) | |  | | |__  | |__) |    | (___ | |__  | (___| (___   | || |  | |  \| |
prompt |  | |\/| | |  | |  _  /| |  | |  __| |  _  /      \___ \|  __|  \___ \\___ \  | || |  | | . ` |
prompt |  | |  | | |__| | | \ \| |__| | |____| | \ \      ____) | |____ ____) |___) |_| || |__| | |\  |
prompt |  |_|  |_|\____/|_|  \_\_____/|______|_|  \_\    |_____/|______|_____/_____/|_____\____/|_| \_|
prompt |                                                                                               
prompt |                                                                                               
prompt |                                                                     
pause
clear screen
prompt |
prompt | A common nuisance for DBAs
prompt |
begin
dbms_output.put_line(q'{
SQL> select sid, serial#, status, last_call_et
  2  from   v$session
  3  where  last_call_et > 60
  4  and    username = 'SCOTT';

      SID    SERIAL# STATUS   LAST_CALL_ET
--------- ---------- -------- ------------
     1116      19453 ACTIVE           2668
     
SQL> pause     
}');
end;
/
pause
prompt SQL> alter system kill session '1116,19453' immediate;;
host sleep 10
prompt alter system kill session '1116,19453' immediate;;
prompt *
prompt ERROR at line 1:
prompt ORA-00031: session marked for kill 

pause SQL> pause
clear screen
prompt SQL> alter system kill session '1116,19453' immediate timeout 3;;
host sleep 2
prompt alter system kill session '1116,19453' immediate timeout 3;;
prompt *
prompt ERROR at line 1:
prompt ORA-00031: session marked for kill 

pause SQL> pause

begin
dbms_output.put_line(q'{
SQL> alter system kill session '1116,19453' force;

System altered.
}');
end;
/
--
-- full disclosure: this demo was artificial
--
set echo on
pause Done
