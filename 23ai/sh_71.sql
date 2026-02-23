clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter session set session_exit_on_package_state_error = false;
drop package pkg;
clear screen
set termout on
set echo off
prompt |   
prompt |   
prompt |      ____  _____                 _  _    ___    __   ___       __  ___   __  
prompt |     / __ \|  __ \     /\        | || |  / _ \  / /  / _ \     / / |__ \  \ \ 
prompt |    | |  | | |__) |   /  \ ______| || |_| | | |/ /_ | (_) |   | |     ) |  | |
prompt |    | |  | |  _  /   / /\ \______|__   _| | | | '_ \ > _ <    | |    / /   | |
prompt |    | |__| | | \ \  / ____ \        | | | |_| | (_) | (_) |   | |   / /_   | |
prompt |     \____/|_|  \_\/_/    \_\       |_|  \___/ \___/ \___/    | |  |____|  | |
prompt |                                                               \_\        /_/ 
prompt |                                                                              
prompt | 
pause
clear screen
set echo on
clear screen
create or replace 
package pkg is
  procedure send_mail;
end;
/
pause
create or replace 
package body pkg  is
  g_mail_server varchar2(100);

  procedure send_mail is 
  begin 
    dbms_output.put_line('Sending to '||g_mail_server);
  end;

begin
  select 'old-server.mail.com' 
  into g_mail_server;
end;
/
pause
set serverout on
exec pkg.send_mail;
--
-- over to session 2 (71a)
--
pause
set serverout on
exec pkg.send_mail;
pause
clear screen
create or replace 
package pkg RESETTABLE is
  procedure send_mail;
end;
/
pause
create or replace 
package body pkg RESETTABLE is
  g_mail_server varchar2(100);

  procedure send_mail is 
  begin 
    dbms_output.put_line('Sending to '||g_mail_server);
  end;

begin
  select 'old-server.mail.com' 
  into g_mail_server;
end;
/
pause
set serverout on
exec pkg.send_mail;
--
-- over to session 2 (71a)
--
pause
set serverout on
exec pkg.send_mail;
pause Done

