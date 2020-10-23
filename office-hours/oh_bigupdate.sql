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
create table t pctfree 1 as
 with 
   lsub as ( select /*+ materialize */ * from ( select * from last_names order by dbms_random.value ) where rownum <= 1000 ),
   fsub as ( select /*+ materialize */ * from ( select * from first_names order by dbms_random.value ) where rownum <= 1000 ),
   x as ( select /*+ materialize */ fname||' '||lname full_name  from fsub, lsub order by dbms_random.value )
   select full_name  from x order by dbms_random.value;   
alter table t add constraint t_pk primary key ( full_name );

@drop t_base
@drop t_interim


@clean
col full_name format a30
col first_name format a30
col last_name format a30
set lines 120
 
set termout on
set echo on
select * from t where rownum <= 10;
select count(*) from t;
pause
create table t_base as select * from t; 
pause

clear screen

alter table t add first_name varchar2(60) 
  generated always as ( 
    cast(substr(full_name,1,instr(full_name,' ')-1) as varchar2(60)));
alter table t add last_name varchar2(60) 
  generated always as ( 
    cast(substr(full_name,instr(full_name,' ')+1) as varchar2(60)));
set lines 90
desc t
pause
set lines 120
clear screen
select * from t where rownum <= 10;
pause

alter table t drop column first_name ;
alter table t drop column last_name ;
pause
clear screen
alter table t add first_name varchar2(60);
alter table t add last_name varchar2(60);
pause
update t
set first_name = substr(full_name,1,instr(full_name,' ')-1),
   last_name = substr(full_name,instr(full_name,' ')+1);

commit;
pause
clear screen

analyze table t compute statistics;

select chain_cnt
from   user_tables
where  table_name = 'T';
pause
alter table t move;
analyze table t compute statistics;

select chain_cnt
from   user_tables
where  table_name = 'T';
pause
clear screen

drop table t purge;
create table t as select * from t_base;
alter table t add primary key ( full_name );

pause
clear screen

create table t_interim (
  full_name     varchar2(121) not null,
  first_name    varchar2(60)  not null,
  last_name     varchar2(60)  not null
);
pause
declare
  l_colmap varchar2(200) := 
    q'{full_name, 
     substr(full_name,1,instr(full_name,' ')-1) as first_name,
     substr(full_name,instr(full_name,' ')+1) as last_name}';
begin
  dbms_redefinition.start_redef_table
       (  uname           => user,
          orig_table      => 'T',
          int_table       => 'T_INTERIM',
          col_mapping   => l_colmap);
end;
/
pause
clear screen

alter table t_interim add primary key ( full_name );
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
select * from t where rownum <= 10;
pause

analyze table t compute statistics;

select chain_cnt
from   user_tables
where  table_name = 'T';
