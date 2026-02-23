set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
set termout on
set echo on
create or replace 
package body pkg  is
  g_mail_server varchar2(100);

  procedure send_mail is 
  begin 
    dbms_output.put_line('Sending to '||g_mail_server);
  end;

begin
  select 'new-server.mail.com' 
  into g_mail_server;
end;
/
--
-- back to session 1
--
pause
clear screen

create or replace 
package body pkg  is
  g_mail_server varchar2(100);

  procedure send_mail is 
  begin 
    dbms_output.put_line('Sending to '||g_mail_server);
  end;

begin
  select 'new-server.mail.com' 
  into g_mail_server;
end;
/
--
-- back to session 1
--
