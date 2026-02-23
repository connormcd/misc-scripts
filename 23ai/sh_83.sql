set termout off
clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
drop user demo cascade;
create user demo identified by demo;
grant create session to demo;
drop table scott.emp_for_demo purge;
@drop t
clear screen
set termout on
set echo off
set lines 1000
set long 5000
set serverout on
set feedback off
clear screen
prompt | 
prompt | 
prompt |    _____ _____            _____  _    _  ____  _      
prompt |   / ____|  __ \     /\   |  __ \| |  | |/ __ \| |     
prompt |  | |  __| |__) |   /  \  | |__) | |__| | |  | | |     
prompt |  | | |_ |  _  /   / /\ \ |  ___/|  __  | |  | | |     
prompt |  | |__| | | \ \  / ____ \| |    | |  | | |__| | |____ 
prompt |   \_____|_|  \_\/_/    \_\_|    |_|  |_|\___\_\______|
prompt |                                                       
prompt |                                                       
prompt |                                                                     
pause
set feedback on
set echo on
clear screen
create or replace 
json relational duality view emp_jdv as
emp {
    _id: empno
    Name: ename
    DeptInfo: dept @link(from: ["DEPTNO"]){
        DepartId: deptno
        DepartName: dname
    }
}
/
pause
col data format a80
set lines 200
set pages 999
clear screen
select * 
from graphql('emp {  _id: empno name: ename}')
.
pause
/
pause
clear screen
select * 
from graphql('
emp {
    _id: empno
    Name: ename
    DeptInfo: dept @link(from: ["DEPTNO"]){
        DepartId: deptno
        DepartName: dname
    }
}');
pause
clear screen
select dbms_json_duality.get_graphql_schema(json('{"schema":"SCOTT"}'))
.
pause
/
pause
with t as ( 
  select dbms_json_duality.get_graphql_schema(json('{"schema":"SCOTT"}')) x
)
select json_serialize(x pretty truncate) 
from t
.
pause
/
pause
clear screen
variable str varchar2(100)
exec :str := 'emp {empno}'
pause
select * from graphql(:str);
pause Done