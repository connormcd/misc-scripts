clear screen
@clean
set termout off
conn dbdemo/dbdemo@db19
set termout off
begin  
    dbms_network_acl_admin.append_host_ace(
         host => 'www.oracle.com',
         ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => user,
                             principal_type => xs_acl.ptype_db)
   );
end;
/
begin  
for i in ( select username from dba_users where username like 'APEX%' ) loop
    dbms_network_acl_admin.append_host_ace(
         host => 'www.oracle.com',
         ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => i.username,
                             principal_type => xs_acl.ptype_db)
   );
end loop;   
end;
/
commit;

conn dbdemo/dbdemo@db23
set termout off
begin  
    dbms_network_acl_admin.append_host_ace(
         host => 'www.oracle.com',
         ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => user,
                             principal_type => xs_acl.ptype_db)
   );
end;
/
begin  
for i in ( select username from dba_users where username like 'APEX%' ) loop

    dbms_network_acl_admin.append_host_ace(
         host => 'www.oracle.com',
         ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => i.username,
                             principal_type => xs_acl.ptype_db)
   );
end loop;   

end;
/

commit;
set verify off
conn dbdemo/dbdemo@db19
set serverout on
set termout on
set echo off
set long 500
prompt |  
prompt |  
prompt |   __          __     _      _      ______ _______ 
prompt |   \ \        / /\   | |    | |    |  ____|__   __|
prompt |    \ \  /\  / /  \  | |    | |    | |__     | |   
prompt |     \ \/  \/ / /\ \ | |    | |    |  __|    | |   
prompt |      \  /\  / ____ \| |____| |____| |____   | |   
prompt |       \/  \/_/    \_\______|______|______|  |_|   
prompt |                                                   
prompt |                                                   
set echo on
pause
clear screen
set echo on
set termout on
select banner from v$version;
pause
declare
  p_url            varchar2(100) := 'https://www.oracle.com';
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_text           varchar2(32767);
begin
  l_http_request  := utl_http.begin_request(p_url);
  l_http_response := utl_http.get_response(l_http_request);
  utl_http.read_text(l_http_response, l_text, 32766);
  dbms_output.put_line(substr(l_text,1,100)); 
exception
    when utl_http.end_of_body then
      utl_http.end_response(l_http_response);
end;
/
pause
select 
  apex_web_service.make_rest_request(
      p_url => 'https://www.oracle.com',
      p_http_method => 'GET')
from dual;
pause
clear screen
conn dbdemo/dbdemo@db23
set termout off
set long 500
set echo off
col object_name format a20
set lines 300
set feedback off
set serverout on
set termout on
begin 
  dbms_output.put_line(
'SQL> select banner from v$version;

BANNER
----------------------------------------------------------
Oracle Database 23ai Enterprise Edition Release 23.0.0.0.0

1 row selected.
');
end;
/
set feedback on
set echo on
pause
declare
  p_url            varchar2(100) := 'https://www.oracle.com';
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_text           varchar2(32767);
begin
  l_http_request  := utl_http.begin_request(p_url);
  l_http_response := utl_http.get_response(l_http_request);
  utl_http.read_text(l_http_response, l_text, 32766);
  dbms_output.put_line(substr(l_text,1,100)); 
exception
    when utl_http.end_of_body then
      utl_http.end_response(l_http_response);
end;
/
pause
select 
  apex_web_service.make_rest_request(
      p_url => 'https://www.oracle.com',
      p_http_method => 'GET')
from dual;

pause Done
