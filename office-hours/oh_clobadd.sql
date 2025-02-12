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
undefine cons
set termout off
col search_condition_vc format a30
set timing off
@drop t
@drop tpar
alter user myuser default tablespace users;
set termout on
clear screen
set echo on
set timing on
create table t tablespace largets as 
select x, owner, object_type, object_name, created, timestamp, object_id
from dba_objects, 
 (select 1 x from dual connect by level <= 12 );
pause
alter table t add c1 varchar2(10) default 'abcdeg' not null;
pause
alter table t add c2 clob default rpad('x',10,'x') not null;
pause
set timing off
clear screen
alter table t add c3 varchar2(10) default 'abcdeg';
pause
select column_id, column_name
from   user_tab_columns
where  table_name = 'T'
order by column_id;
pause
select column_name,hidden_column, column_id, internal_column_id
from   user_tab_cols
where  table_name = 'T'
order by internal_column_id;
pause
clear screen
select *
from   user_tab_cols
where  column_id is null
and    table_name = 'T'
@pr
pause
clear screen
select SYS_NC00010$
from   t
where  SYS_NC00010$ is not null;
pause
clear screen
create table tpar 
partition by list (x )
( partition p1 values (1),
  partition p2 values (2)
)
as select * from t 
where 1=0;
pause
alter table tpar exchange partition p1 with table t;
pause
clear screen
alter table t add c4 clob default rpad('x',10,'x')

pause
/
pause
analyze table t compute statistics;
pause
select chain_cnt
from   user_tables
where  table_name = 'T';
pause

clear screen
alter table t add c5 clob;
pause
alter table t modify c5 default rpad('x',10,'x');
pause
begin
  dbms_redefinition.execute_update(
    q'{update t set c5 = rpad('x',10,'x')}'
  );
end;
/
pause
alter table t modify c5 not null novalidate;
pause
col constraint_name new_value cons
select constraint_name, search_condition_vc
from   user_constraints
where  table_name = 'T'
and    search_condition_vc like '%C5%';
pause
alter table t modify constraint &&cons enable validate;
pause
analyze table t compute statistics;
pause
select chain_cnt
from   user_tables
where  table_name = 'T';
