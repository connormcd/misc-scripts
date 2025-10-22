clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
alter session set read_only = false;
drop domain amex ;
@drop credit_card
@drop emp2
exec dbms_search.drop_index('BIG_SEARCH');
delete from scott.dept where deptno = 99;
commit;
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |
prompt |  _____  ____  __  __  _____     _____ ______          _____   _____ _    _ 
prompt | |  __ \|  _ \|  \/  |/ ____|   / ____|  ____|   /\   |  __ \ / ____| |  | |
prompt | | |  | | |_) | \  / | (___    | (___ | |__     /  \  | |__) | |    | |__| |
prompt | | |  | |  _ <| |\/| |\___ \    \___ \|  __|   / /\ \ |  _  /| |    |  __  |
prompt | | |__| | |_) | |  | |____) |   ____) | |____ / ____ \| | \ \| |____| |  | |
prompt | |_____/|____/|_|  |_|_____/   |_____/|______/_/    \_\_|  \_\\_____|_|  |_|
prompt |                                                                           
pause
prompt |                                                                           
prompt |                                                                           
prompt |  Customer - Why can't the database be just like Google?                                                                          
prompt |                                                                           
prompt |  
pause
set echo on
clear screen
set echo on
set termout on
exec dbms_search.create_index('BIG_SEARCH');
exec dbms_search.add_source('BIG_SEARCH','SCOTT.EMP');
exec dbms_search.add_source('BIG_SEARCH','SCOTT.DEPT');
pause
set lines 60
clear screen
desc BIG_SEARCH
pause
set lines 120
clear screen
select table_name
from   user_tables
where  table_name like '%BIG_SEARCH%';
pause
clear screen
select metadata from big_search;
pause
clear screen
select data  from big_search;
pause
clear scree
select metadata 
from big_search 
where json_textcontains(
        data,'$.SCOTT.EMP.ENAME','KING');
pause
clear screen
select metadata 
from big_search  
where contains(data,'SALESMAN or BOSTON')>0;
pause
clear screen
select e.ename, e.hiredate 
from big_search b, scott.emp e
where json_textcontains(
        data,'$.SCOTT.EMP.ENAME','KING')
and e.empno = to_number(b.metadata.KEY.EMPNO);
pause
clear screen
select dbms_search.get_document(owner||'.'||source,metadata) 
from big_search
where contains(data,'SALESMAN or BOSTON')>0;
pause
clear screen
insert into scott.dept
values (99,'ADVOCATE','PERTH');
commit;
select metadata 
from big_search  
where contains(data,'PERTH')>0;
pause    
select metadata 
from big_search  
where contains(data,'PERTH')>0;
pause    
select metadata 
from big_search  
where contains(data,'PERTH')>0;
pause    
select metadata 
from big_search  
where contains(data,'PERTH')>0;
pause    
exec dbms_search.drop_index('BIG_SEARCH');
delete from scott.dept where deptno = 99;
commit;

pause Done


