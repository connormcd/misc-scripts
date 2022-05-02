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
conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
drop table t purge;
set serverout off
set termout on
set echo on
clear screen
create or replace
procedure myuser.list_emps is
begin
  for i in ( select * from scott.emp ) 
  loop
     dbms_output.put_line(i.empno||','||i.ename||','||i.hiredate);
  end loop;
end;
/
pause
exec myuser.list_emps
pause
clear screen
set serverout on
pause
exec myuser.list_emps
pause
clear screen
set serverout off
pause
create table t ( m varchar2(100));
pause
declare
  line   varchar2(1000);
  status integer;
begin
  myuser.list_emps;

  dbms_output.get_line( line, status);
  while ( line is not null ) loop
    insert into t values (line);
    commit;
    dbms_output.get_line( line, status);
  end loop;
end;
/
pause
select * from t;
pause
clear screen
declare
  line   varchar2(1000);
  status integer;
begin
  dbms_output.enable;
  myuser.list_emps;
#pause

  dbms_output.get_line( line, status);
  while ( line is not null ) loop
    insert into t values (line);
    commit;
    dbms_output.get_line( line, status);
  end loop;
end;
/
pause
select * from t;
pause
clear screen
create or replace
procedure myuser.dbmsout is
  line  varchar2(1000);
  status integer;
begin
  htp.p('<p>Output<br><br></p><pre style="font-family: Consolas,Courier,monospace;">');
  
  dbms_output.enable;
  myuser.list_emps;

  dbms_output.get_line( line, status);
  while ( line is not null ) loop
    htp.p(line||'<br>');
    dbms_output.get_line( line, status);
  end loop;
  htp.p('</pre>');
end;
/
pause
set echo off
pro
pro  http://localhost:8089/ords/myuser.dbmsout
pro
