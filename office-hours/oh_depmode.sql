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
drop public database link db19s;
create public database link db19s connect to scott identified by tiger using '//localhost:1519/db19s';
set termout off
clear screen
set timing off
set feedback on
set echo on
clear screen
set termout on
show parameter remote_dep
pause
conn scott/tiger@DB_SERVICE
create or replace
procedure referenced_procedure (pi_value in NUMBER) is
begin
  dbms_output.put_line('referenced_procedure');
end;
/
pause
create or replace procedure dependent_procedure is
begin
  dbms_output.put_line('dependent_procedure');
  referenced_procedure(5);
end;
/
pause
clear screen
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
pause
create or replace
procedure referenced_procedure (pi_value in INT) is
begin
  dbms_output.put_line('referenced_procedure');
end;
/
pause
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
pause
clear screen
drop procedure referenced_procedure;
drop procedure dependent_procedure;
alter session set remote_dependencies_mode = 'signature';
pause
create or replace
procedure referenced_procedure (pi_value in NUMBER) is
begin
  dbms_output.put_line('referenced_procedure');
end;
/
pause
create or replace procedure dependent_procedure is
begin
  dbms_output.put_line('dependent_procedure');
  referenced_procedure(5);
end;
/
pause
clear screen
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
pause
create or replace
procedure referenced_procedure (pi_value in INT) is
begin
  dbms_output.put_line('referenced_procedure');
end;
/
pause
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
pause
clear screen
-------------------------------------------------
--
-- The REMOTE in remote_dependencies_mode :-)
--
-------------------------------------------------

conn scott/tiger@DB_SERVICE
create or replace
procedure referenced_procedure (pi_value in NUMBER) is
begin
  dbms_output.put_line('referenced_procedure');
end;
/
pause
conn scott/tiger@DB_SERVICE
create or replace procedure dependent_procedure is
begin
  dbms_output.put_line('dependent_procedure');
  referenced_procedure@DB_SERVICE(5);
end;
/
pause
clear screen
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
pause
conn scott/tiger@DB_SERVICE
create or replace
procedure referenced_procedure (pi_value in INT) is
begin
  dbms_output.put_line('referenced_procedure');
end;
/
pause
conn scott/tiger@DB_SERVICE
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
pause
set serverout on
exec dependent_procedure
pause
clear screen
conn scott/tiger@DB_SERVICE
create or replace
  procedure referenced_procedure (pi_value in NUMBER) is
  begin
    dbms_output.put_line('referenced_procedure');
  end;
/
conn scott/tiger@DB_SERVICE
create or replace procedure dependent_procedure is
begin
  dbms_output.put_line('dependent_procedure');
  referenced_procedure@DB_SERVICE(5);
end;
/
pause
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
set serverout on
exec dependent_procedure
pause
clear screen
conn scott/tiger@DB_SERVICE
create or replace
procedure referenced_procedure (pi_value in INT) is
begin
  dbms_output.put_line('referenced_procedure');
end;
/
conn scott/tiger@DB_SERVICE
select object_name, object_type, status
  from user_objects
 where object_name in ('DEPENDENT_PROCEDURE');
pause
alter session set remote_dependencies_mode = 'signature';
pause
exec DEPENDENT_PROCEDURE
