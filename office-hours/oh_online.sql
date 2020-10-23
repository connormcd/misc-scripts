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
@drop t_par
@clean
set termout on
set echo on
create table T as
select *
from dba_Objects
where object_id is not null;
pause
alter table t add constraint t_pk primary key ( object_id );
create index t_ix on t ( created, object_name );
pause
clear screen
create table t_par
partition by range (object_id) interval (10000)
 (
  partition p1 values less than (20000) 
 )
as select * from t where 1=0;
pause
clear screen
begin
  dbms_redefinition.start_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_PAR');
end;
/
pause
clear screen
alter table t_par add constraint t_par_pk primary key ( object_id ) using index local;
create index t_par_ix on t_par ( created ) 
   global partition by range (created)
     (
       partition ix2_p1 values less than (date '2016-08-01'),
       partition ix2_p2 values less than (maxvalue)
     );
pause

clear screen
set serverout on
declare
  n int;
begin
  dbms_redefinition.copy_table_dependents
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_PAR',
          copy_indexes    =>0,
          copy_triggers   =>true,
          copy_constraints=>false,
          copy_privileges =>true,
          num_errors      =>n);
  dbms_output.put_line(n);
end;
/
pause
clear screen
begin
  dbms_redefinition.finish_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_PAR');
end;
/
