REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

conn USER/PASSWORD@MY_DB
set echo on
drop user demo cascade;
pause
create user demo identified by demo;
grant connect, resource to demo;
alter user demo quota unlimited on users;
pause
clear screen
create or replace
procedure scott.sample_proc is
begin
  dbms_output.put_line('Hi there!');
end;
/
exit