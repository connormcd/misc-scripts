clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
drop table emp_temp purge;
conn dbdemo/dbdemo@db19
set termout off
drop table emp_temp purge;
clear screen
set termout on
set echo off
set serverout on
prompt |   
prompt |   
prompt |     __  __ ______ _____   _____ ______ 
prompt |    |  \/  |  ____|  __ \ / ____|  ____|
prompt |    | \  / | |__  | |__) | |  __| |__   
prompt |    | |\/| |  __| |  _  /| | |_ |  __|  
prompt |    | |  | | |____| | \ \| |__| | |____ 
prompt |    |_|  |_|______|_|  \_\\_____|______|
prompt |                                        
prompt |                                        
prompt |   
pause
set echo on
clear screen
select banner_full from v$version;
pause
create table emp_temp as
select * from hr.employees
where department_id in (10,20);
pause
clear screen
merge into emp_temp t
using ( select * from hr.employees
        where department_id in (20,30) ) x
on (t.employee_id = x.employee_id)
when matched then
  update set t.salary = x.salary
when not matched then
  insert values 
    (x.employee_id,x.first_name     
    ,x.last_name,x.email          
    ,x.phone_number,x.hire_date      
    ,x.job_id,x.salary         
    ,x.commission_pct,x.manager_id     
    ,x.department_id  );
pause
roll;
clear screen
declare
  l_enums  sys.odcinumberlist;
  l_names  sys.odcivarchar2list;
begin
  merge into emp_temp t
  using ( select * from hr.employees
          where department_id in (20,30) ) x
  on (t.employee_id = x.employee_id)
  when matched then
    update set t.salary = x.salary
  when not matched then
    insert values 
      (x.employee_id,x.first_name     
      ,x.last_name,x.email          
      ,x.phone_number,x.hire_date      
      ,x.job_id,x.salary         
      ,x.commission_pct,x.manager_id     
      ,x.department_id  )
  RETURNING employee_id, last_name
  bulk collect into l_enums, l_names;
end;
.
pause
/
pause
roll;
set echo off
clear screen
conn dbdemo/dbdemo@db23
set lines 300
set feedback off
set serverout on
set termout on

set feedback on
set echo on
select banner from v$version;
pause

create table emp_temp as
select * from hr.employees
where department_id in (10,20);
pause
clear screen
declare
  l_enums  sys.odcinumberlist;
  l_names  sys.odcivarchar2list;
begin
  merge into emp_temp t
  using ( select * from hr.employees
          where department_id in (20,30) ) x
  on (t.employee_id = x.employee_id)
  when matched then
    update set t.salary = x.salary
  when not matched then
    insert values 
      (x.employee_id,x.first_name     
      ,x.last_name,x.email          
      ,x.phone_number,x.hire_date      
      ,x.job_id,x.salary         
      ,x.commission_pct,x.manager_id     
      ,x.department_id  )
  returning employee_id, last_name
  bulk collect into l_enums, l_names;

  for i in l_enums.first .. l_enums.last
  loop
    dbms_output.put_line('emp-'||l_enums(i)||':'||l_names(i));
  end loop;    
end;
.
pause
/
pause
roll;
clear screen
declare
  l_enums  sys.odcinumberlist;
  l_names  sys.odcivarchar2list;
begin
  insert into emp_temp t
  select * from hr.employees
  where department_id in (20,30) 
  returning employee_id, last_name
  bulk collect into l_enums, l_names;
#pause
  for i in l_enums.first .. l_enums.last
  loop
    dbms_output.put_line('emp-'||l_enums(i)||':'||l_names(i));
  end loop;  
end;
.
pause
/
pause
clear screen
merge into emp_temp t
using ( select * from hr.employees
        where department_id = 30 ) x
#pause  
on (1=0)
#pause
when not matched then
  insert values 
    (x.employee_id,x.first_name     
    ,x.last_name,x.email          
    ,x.phone_number,x.hire_date      
    ,x.job_id,x.salary         
    ,x.commission_pct,x.manager_id     
    ,x.department_id  )
.
pause
/
pause
roll;
clear screen
declare
  l_enums  sys.odcinumberlist;
  l_names  sys.odcivarchar2list;
begin
  merge into emp_temp t
  using ( select * from hr.employees
          where department_id = 30 ) x
  on (1=0)
  when not matched then
    insert values 
      (x.employee_id,x.first_name     
      ,x.last_name,x.email          
      ,x.phone_number,x.hire_date      
      ,x.job_id,x.salary         
      ,x.commission_pct,x.manager_id     
      ,x.department_id  )
  returning employee_id, last_name
  bulk collect into l_enums, l_names;

  for i in l_enums.first .. l_enums.last
  loop
    dbms_output.put_line('emp-'||l_enums(i)||':'||l_names(i));
  end loop;  
end;
.
pause
/
pause
clear screen
declare
  l_enums  sys.odcinumberlist;
  l_names  sys.odcivarchar2list;
begin
  merge into emp_temp t
  using ( select * from hr.employees
          where department_id = 30 ) x
  on (x.employee_id = x.employee_id-1)
#pause  
  when not matched then
    insert values 
      (x.employee_id,x.first_name     
      ,x.last_name,x.email          
      ,x.phone_number,x.hire_date      
      ,x.job_id,x.salary         
      ,x.commission_pct,x.manager_id     
      ,x.department_id  )
  returning employee_id, last_name
  bulk collect into l_enums, l_names;

  for i in l_enums.first .. l_enums.last
  loop
    dbms_output.put_line('emp-'||l_enums(i)||':'||l_names(i));
  end loop;  
end;
.
pause
/

pause Done