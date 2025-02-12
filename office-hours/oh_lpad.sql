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
alter session set plsql_optimize_level  =2;
set termout on
set echo on
create or replace
procedure my_proc is
  l_myvar varchar2(2000);
begin
  l_myvar := lpad('x',2000,'x');
end;
.
pause
set timing on
/
pause
create or replace
procedure my_proc is
  l_myvar varchar2(8000);
begin
  l_myvar := lpad('x',8000,'x');
end;
.
pause
/
pause
create or replace
procedure my_proc is
  l_myvar varchar2(32767);
begin
  l_myvar := lpad('x',32767,'x');
end;
.
pause
/
pause
create or replace
procedure my_proc is
  l_myvar varchar2(32767);
begin
  l_myvar := lpad('x',32767,'x');
  l_myvar := lpad('x',32767,'x');
  l_myvar := lpad('x',32767,'x');
  l_myvar := lpad('x',32767,'x');
end;
.
pause
/
pause
clear screen
set serverout on
declare
  l_ddl varchar2(200) := q'{create or replace procedure test_proc as x varchar2(@@); begin x := rpad('x', @@);  end;}';
  l_duration timestamp;
begin
  for i in 1 .. 16 loop
    l_duration := localtimestamp;
    execute immediate replace(l_ddl,'@@',i*2000);
    dbms_output.put_line(rpad((i*2)||'k:',6)||substr((localtimestamp-l_duration),18));
  end loop;
end;
.
pause
/
pause
clear screen
alter session set plsql_optimize_level = 0;
pause
declare
  l_ddl varchar2(200) := q'{create or replace procedure test_proc as x varchar2(@@); begin x := rpad('x', @@);  end;}';
  l_duration timestamp;
begin
  for i in 1 .. 16 loop
    l_duration := localtimestamp;
    execute immediate replace(l_ddl,'@@',i*2000);
    dbms_output.put_line(rpad((i*2)||'k:',6)||substr((localtimestamp-l_duration),18));
  end loop;
end;
/


