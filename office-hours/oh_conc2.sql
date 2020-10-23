REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
clear screen
@clean
set lines 120
set echo on
create or replace 
procedure reset_to_empty is
begin
  delete book;
  delete trans;
  insert into book values (1,'OPEN',null,null);
  execute immediate 'alter sequence audit_seq restart';
end;
/
pause
set echo off
clear screen
pro
pro Ready...back to session 1
pro 
set echo on
pause
exec new_trans;
set echo off
pro
pro Back to session 1
pro
set echo on
pause
clear screen
exec new_trans;
exec new_trans;
exec new_trans;
set echo off
pro
pro Back to session 1
pro
set echo on
pause
exec new_trans;
