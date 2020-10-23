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
conn USER/PASSWORD
alter session set smtp_out_server = '';
set termout on
@clean
set echo on

show parameter smtp_out_server
pause

alter session set smtp_out_server = 'mailhost1.oracle.com';
pause

clear screen
create or replace
procedure my_mailer(p_recip varchar2) is
begin
  --
  -- blah blah
  --
  utl_mail.send(
    sender=>'connor@oracle.com',
    recipients=>p_recip,
    subject=>'My Subject',
    message=>'My Message');
end;
/
pause

clear screen

create or replace
procedure my_mailer(p_recip varchar2, p_mode varchar2) is
begin
  --
  -- blah blah
  --
  
  if p_mode = 'internal' then
    execute immediate 
       'alter session set smtp_out_server = ''mailhost1.oracle.com''';
  elsif p_mode = 'internal' then
    execute immediate 
       'alter session set smtp_out_server = ''mailhost2.oracle.com''';
  end if;
  
  utl_mail.send(
    sender=>'connor@oracle.com',
    recipients=>p_recip,
    subject=>'My Subject',
    message=>'My Message');
end;
/
