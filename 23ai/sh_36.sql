clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set long 1000
clear screen
@drop t
@drop t1
@drop jc
drop view jdv;
@drop JDV_CUSTOMER_INFO
@drop JDV_ORDER_ITEMS
@drop JDV_ROOT
@drop emp
create table emp as select * from scott.emp;
set termout on
set echo off
prompt | 
prompt | 
prompt |    _____  ____       __  __ _    _  _____ _    _           _  _____  ____  _   _ 
prompt |   / ____|/ __ \     |  \/  | |  | |/ ____| |  | |         | |/ ____|/ __ \| \ | |
prompt |  | (___ | |  | |    | \  / | |  | | |    | |__| |         | | (___ | |  | |  \| |
prompt |   \___ \| |  | |    | |\/| | |  | | |    |  __  |     _   | |\___ \| |  | | . ` |
prompt |   ____) | |__| |    | |  | | |__| | |____| |  | |    | |__| |____) | |__| | |\  |
prompt |  |_____/ \____/     |_|  |_|\____/ \_____|_|  |_|     \____/|_____/ \____/|_| \_|
prompt |                                                                                  
prompt | 
prompt | 
set echo on
pause
create table t as 
select ename, sal, comm
from scott.emp
where deptno = 30;
pause
select * from t;
pause
clear screen
--
-- better empty handling
--
select json{*} from t;
pause
select json{* absent on null} from t;
pause
select json{* empty string on null} from t;
pause
clear screen
--
-- better error handling
--
drop table t purge;
pause
create table t ( j json);
pause
begin
  insert into t values (
  '{ "name"     : "Connor",
     "email"    : "connor@oracle.com",
     "salary"   : 0,
     "location" : "Perth"
   }');
end;
/
pause
select json_value(j,'$.name') from t;
pause
select json_value(j,'$.city') from t;
pause
select json_value(j,'$.city' error on error) from t;
pause
clear screen
alter session set json_behavior='on_error:error';
pause
select json_value(j,'$.city') from t;
pause
alter session set json_behavior='on_error:null';
pause
select json_value(j,'$.city') from t;
pause
clear screen
--
-- better array handling
--
pause
select 
  json_object('d':dname) org
from dept;
pause
select 
  json_object(
    'd':dname,
    'e': ( select json_array(empno)
           from   emp
           where  emp.deptno = dept.deptno
         )
     ) 
from dept

pause
/
pause
select 
  json_object(
    'd':dname,
    'e': ( select json_arrayagg(empno)
           from   emp
           where  emp.deptno = dept.deptno
         )
     ) org
from dept;
pause
select 
  json_object(
    'd':dname,
    'e': json_array( select empno
           from   emp
           where  emp.deptno = dept.deptno
         )
     ) org
from dept;
pause
clear screen
drop table t purge;
--
-- better .... sorting?
--
pause
create table t ( j json);
begin
  insert into t values (
  '{ "name"     : "Connor",
     "email"    : "connor@oracle.com",
     "salary"   : 0,
     "location" : "Perth"
   }');
end;
/
pause
select json_serialize(j pretty) from t;
pause
select json_serialize(j ordered) from t;
pause
select json_serialize(j ordered pretty) from t;
pause
select json_serialize(j pretty ordered ) from t;
pause
clear screen
drop table t purge;
create table t ( j json);
--
-- ORDER BY for json
--
pause
insert into t values 
  (json('{"ename":"CLARK" ,"sal":2450,"dname":"ACCOUNTING","deptno":10}')),
  (json('{"ename":"KING"  ,"sal":5000,"dname":"ACCOUNTING","deptno":10}')),
  (json('{"ename":"MILLER","sal":1300,"dname":"ACCOUNTING","deptno":10}')),
  (json('{"ename":"JONES" ,"sal":2975,"dname":"RESEARCH"  ,"deptno":20}')),
  (json('{"ename":"FORD"  ,"sal":3000,"dname":"RESEARCH"  ,"deptno":20}')),
  (json('{"ename":"ADAMS" ,"sal":1100,"dname":"RESEARCH"  ,"deptno":20}'));
commit;
select * from t;
pause
select * from t order by j;
pause
delete t;
insert into t values 
  (json('{"name":"CLARK" ,"sal":2450,"dname":"ACCOUNTING","deptno":10}')),
  (json('{"name":"KING"  ,"maxsal":5000,"dname":"ACCOUNTING","deptno":10}')),
  (json('{"name":"MILLER","sal":1300,"dname":"ACCOUNTING","deptno":10}')),
  (json('{"firstname":"JONES" ,"sal":2975,"dname":"RESEARCH"  ,"deptno":20}')),
  (json('{"firstname":"FORD"  ,"sal":3000,"dname":"RESEARCH"  ,"deptno":20}')),
  (json('{"forename":"ADAMS" ,"sal":1100,"dname":"RESEARCH"  ,"deptno":20}'));
pause
select * from t order by j;
pause
clear screen
drop table t purge;
--
-- better search
--
pause
create table t ( j json);
pause
begin
  insert into t values (
   json( '[
       {"ename":"CLARK","sal":2450,"dname":"ACCOUNTING","deptno":10}
      ,{"ename":"KING","sal":5000,"dname":"ACCOUNTING","deptno":10}
      ,{"ename":"MILLER","sal":1300,"dname":"ACCOUNTING","deptno":10}
      ,{"ename":"JONES","sal":2975,"dname":"RESEARCH","deptno":20}
      ,{"ename":"FORD","sal":3000,"dname":"RESEARCH","deptno":20}
      ,{"ename":"ADAMS","sal":1100,"dname":"RESEARCH","deptno":20}
      ,{"ename":"SMITH","sal":800,"dname":"RESEARCH","deptno":20}
      ,{"ename":"SCOTT","sal":3000,"dname":"RESEARCH","deptno":20}
      ,{"ename":"WARD","sal":1250,"dname":"SALES","deptno":30}
      ,{"ename":"TURNER","sal":1500,"dname":"SALES","deptno":30}
      ,{"ename":"ALLEN","sal":1600,"dname":"SALES","deptno":30}
      ,{"ename":"JAMES","sal":950,"dname":"SALES","deptno":30}
      ,{"ename":"BLAKE","sal":2850,"dname":"SALES","deptno":30}
      ,{"ename":"MARTIN","sal":1250,"dname":"SALES","deptno":30}
      ]'));
end;
/
pause
select json_query(j, '$') as result
from t;
pause
select json_query(j, '$[3]') as result
from t;
pause
select json_query(j, '$[*]?(@.ename == "CLARK")') as result
from t;


pause
col status format a42
drop table t purge;
clear screen
--
-- Making the leap to JSON
--
create table t ( j clob);
insert into t values 
 ( '  { "first_name": "Patrick", "last_name": "Mahomes" } '),
 ( '  { "first_name": "Aaron", "last_name": "Donald" }'),
 ( '  { "first_name": "Josh", "last_name": "Allen" }'),
 ( '  { "first_name": "Derrick", "last_name": "Henry" }'),
 ( '  { "first_name": "Jalen" , "last_name": "Ramsey"'),
 ( '  { "first_name": "Travis", "last_name": "Kelce" }'),
 ( '  { "first_name": "Stefon", "last_name": "Diggs" }'),
 ( '  { "first_name": "Myles", "last_name": "Garrett" }');
commit;
pause
create table t1 
as select json(j) js from t;
pause
clear screen
drop table if exists json_conversion purge;
begin
  dbms_json.json_type_convertible_check(
    owner           => user,
    tablename       => 'T',
    columnname      => 'J',
    statustablename => 'json_conversion'
  );
end;
/
pause
desc json_conversion
pause
select status, error_row_id from json_conversion;
pause
select *
from t
where rowid in 
  ( select error_row_id 
    from json_conversion
    where error_row_id is not null );

pause
clear screen
--
-- for the dinosaurs :-)
--
pause
drop table t purge;
create table t ( j json);
begin
  insert into t values (
  '{ "name"     : "Connor",
     "email"    : "connor@oracle.com",
     "salary"   : 0,
     "location" : ["Perth","Sydney","Melbourne"]
   }');
end;
/
pause
select jsontoxml(j) from t;

pause Done
