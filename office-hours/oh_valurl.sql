REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

clear screen
@clean
set termout off
conn USER/PASSWORD@MY_PDB
set termout off
col emp_posn format a30
set termout on
set lines 120
@drop t
drop function emp_plus_dname;
drop view emp_plus_dname;
clear screen
set feedback on
set serverout on
set echo on
--
-- https://connor-mcdonald.com  ???
--
pause
host wget https://connor-mcdonald.com
pause
host curl -L -o nul -s -w "%{http_code}\n" https://connor-mcdonald.com
pause
clear screen
set serverout on
declare
  p_url            varchar2(100) := 'https://connor-mcdonald.com';
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_status         int;
begin
  utl_http.set_wallet('system:');
  l_http_request  := utl_http.begin_request(p_url);

  l_http_response := utl_http.get_response(l_http_request);
  
  l_status :=  l_http_response.status_code; 
  dbms_output.put_line('response code is '||l_status);
  utl_http.end_response(l_http_response);
end;
.
pause
/
pause
clear screen
declare
  p_url            varchar2(100) := 'https://linkedin.com';
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_status         int;
begin
  utl_http.set_wallet('system:');
  l_http_request  := utl_http.begin_request(p_url);

  l_http_response := utl_http.get_response(l_http_request);
  
  l_status :=  l_http_response.status_code; 
  dbms_output.put_line('response code is '||l_status);
  utl_http.end_response(l_http_response);
end;
.
pause
/
pause
clear screen
set serverout on
declare
  p_url            varchar2(100) := 'https://www.oracle.com';
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_status         int;
begin
  utl_http.set_wallet('system:');
  l_http_request  := utl_http.begin_request(p_url);

  l_http_response := utl_http.get_response(l_http_request);
  
  l_status :=  l_http_response.status_code; 
  dbms_output.put_line('response code is '||l_status);
  utl_http.end_response(l_http_response);
end;
.
pause
/
pause
clear screen
set serverout on
declare
  p_url            varchar2(100) := 'https://www.oracle.com';
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_status         int;
begin
  utl_http.set_wallet('system:');
  l_http_request  := utl_http.begin_request(p_url);
  utl_http.set_header(l_http_request, 'accept','text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' );
  utl_http.set_header(l_http_request, 'accept-language','en-GB,en-US;q=0.9,en;q=0.8' );
  utl_http.set_header(l_http_request, 'cache-control','no-cache' );
  utl_http.set_header(l_http_request, 'pragma','no-cache' );
  utl_http.set_header(l_http_request, 'priority','u=0, i' );
  utl_http.set_header(l_http_request, 'sec-ch-ua','"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"' );
  utl_http.set_header(l_http_request, 'sec-ch-ua-mobile','?1' );
  utl_http.set_header(l_http_request, 'sec-ch-ua-platform','"Android"' );
  utl_http.set_header(l_http_request, 'sec-fetch-dest','document' );
  utl_http.set_header(l_http_request, 'sec-fetch-mode','navigate' );
  utl_http.set_header(l_http_request, 'sec-fetch-site','same-origin' );
  utl_http.set_header(l_http_request, 'sec-fetch-user','?1' );
  utl_http.set_header(l_http_request, 'upgrade-insecure-requests','1' );
  utl_http.set_header(l_http_request, 'user-agent','Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36'  );
  l_http_response := utl_http.get_response(l_http_request);
  
  l_status :=  l_http_response.status_code; 
  dbms_output.put_line('response code is '||l_status);
  utl_http.end_response(l_http_response);
end;
.
pause
/
pause
clear screen
set serverout on
declare
  p_url            varchar2(100) := 'https://www.oracle.com';
  l_http_request   utl_http.req;
  l_http_response  utl_http.resp;
  l_status         int;
begin
  utl_http.set_wallet('system:');
  l_http_request  := utl_http.begin_request(p_url);
  utl_http.set_header(l_http_request, 'accept','text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' );
  utl_http.set_header(l_http_request, 'priority','u=0, i' );
  utl_http.set_header(l_http_request, 'user-agent','Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36'  );
  l_http_response := utl_http.get_response(l_http_request);
  
  l_status :=  l_http_response.status_code; 
  dbms_output.put_line('response code is '||l_status);
  utl_http.end_response(l_http_response);
end;
.
pause
/
