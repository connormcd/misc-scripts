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
@drop t
@drop t_interim
@clean
set termout on
set echo on
create table t as
select 
   to_char(object_id) pk
  ,owner
  ,object_name
  ,subobject_name
  ,object_id
  ,data_object_id
from all_objects
where object_id is not null;
alter table t add primary key ( pk );
pause

clear screen

create table t_interim as 
select 
   object_id pk
  ,owner
  ,object_name
  ,subobject_name
  ,object_id
  ,data_object_id
from all_objects
where 1=0;

pause
clear screen
desc t
pause
clear screen
desc t_interim
pause

begin
  dbms_redefinition.start_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_INTERIM'
          );
end;
/
pause

clear screen
declare
  l_colmap varchar2(200) := 
    q'{   to_number(pk) as pk
         ,owner
         ,object_name
         ,subobject_name
         ,object_id
         ,data_object_id}';
begin
  dbms_redefinition.start_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_INTERIM',
          col_mapping   => l_colmap
          );
end;
/
pause

clear screen
begin
  dbms_redefinition.abort_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_INTERIM'
          );
end;
/
pause

clear screen
declare
  l_colmap varchar2(200) := 
    q'{   to_number(pk) as pk
         ,owner
         ,object_name
         ,subobject_name
         ,object_id
         ,data_object_id}';
begin
  dbms_redefinition.start_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_INTERIM',
          col_mapping   => l_colmap,
          options_flag=>DBMS_REDEFINITION.cons_use_rowid
          );
end;
/
pause
clear screen

alter table t_interim add primary key ( pk );
pause
begin
  dbms_redefinition.finish_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_INTERIM');
end;
/
pause
clear screen
desc t
pause
