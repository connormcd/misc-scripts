clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter session set session_exit_on_package_state_error = false;
conn dbdemo/dbdemo@db19
clear screen
set termout on
set echo off
prompt | 
prompt |    ____  _____                 _  _    ___    __   ___  
prompt |   / __ \|  __ \     /\        | || |  / _ \  / /  / _ \ 
prompt |  | |  | | |__) |   /  \ ______| || |_| | | |/ /_ | (_) |
prompt |  | |  | |  _  /   / /\ \______|__   _| | | | '_ \ > _ < 
prompt |  | |__| | | \ \  / ____ \        | | | |_| | (_) | (_) |
prompt |   \____/|_|  \_\/_/    \_\       |_|  \___/ \___/ \___/ 
prompt |                                                         
prompt |                                                         
prompt | 
pause
set echo on
create or replace
package mypkg is
   procedure p;
end;
/
pause
create or replace
package body mypkg is
   my_global int := 0;

   procedure p is
   begin  
     my_global := my_global + 1;
     dbms_output.put_line('my_global='||my_global);
   end;
end;
/
pause
clear screen
set serverout on
exec mypkg.p;
pause
exec mypkg.p;
pause
exec mypkg.p;
pause
exec mypkg.p;
pause
exec mypkg.p;
--
-- over to session 2 (55a)
--
pause
exec mypkg.p;
pause
clear screen
--
-- THIS WAS A GOOD THING !!!
--
pause
begin
  mypkg.p;
exception
  when others then null;
end;
/
--
-- over to session 2
--
pause
begin
  mypkg.p;
exception
  when others then null;
end;
/
pause
begin
  mypkg.p;
exception
  when others then null;
end;
/
--
-- where is my output????
--
pause
conn dbdemo/dbdemo@db23
clear screen
create or replace
package body mypkg is
   my_global int := 0;

   procedure p is
   begin  
     my_global := my_global + 1;
     dbms_output.put_line('my_global='||my_global);
   end;
end;
/
exec mypkg.p;
--
-- over to session 2
--
pause
clear screen
alter session set session_exit_on_package_state_error = true;
pause
exec mypkg.p;
pause
select * from dual;
pause
set echo off
clear screen
set termout off
conn dbdemo/dbdemo@db23
set termout on
set echo on
alter session set session_exit_on_package_state_error = true;
exec mypkg.p;
--
-- over to session 2
--
pause
begin
  mypkg.p;
exception
  when others then null;
end;
/
pause
select * from dual;

pause Done
