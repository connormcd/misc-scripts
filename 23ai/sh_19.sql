clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
drop user jane_doe cascade;
drop domain amex ;
@drop t1
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
alter table products modify total_sold not reservable;
@drop products
@drop seq
@drop myemp
@drop customer
@drop dept_doc
@drop orders
@drop orderitems
col journal new_value journal_table
col journal format a30
set verify off
drop view orders_ov;
@dropc order_items
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
col first_name format a20
col last_name format a20
clear screen
set termout on
set echo off
prompt |
prompt |
prompt |   ___  ____      _ _____ ____ _____   __         _ ____   ___  _   _ 
prompt |  / _ \| __ )    | | ____/ ___|_   _|  \ \       | / ___| / _ \| \ | |
prompt | | | | |  _ \ _  | |  _|| |     | |     \ \   _  | \___ \| | | |  \| |
prompt | | |_| | |_) | |_| | |__| |___  | |     / /  | |_| |___) | |_| | |\  |
prompt |  \___/|____/ \___/|_____\____| |_|    /_/    \___/|____/ \___/|_| \_|
prompt |                                                                    
prompt |
pause
set echo on
clear screen
set echo on
set termout on
declare
  type dept_list is 
    table of dept%rowtype
    index by pls_integer;
 
  l_dept dept_list;
begin
  select *
  bulk collect 
  into l_dept
  from dept;
end;
/
pause
set serverout on
declare
  type dept_list is 
    table of dept%rowtype
    index by pls_integer;
 
  l_dept dept_list;
  l_json json_object_t := json_object_t();
  l_row  json_object_t := json_object_t();
begin
  select *
  bulk collect 
  into l_dept
  from dept;
  
  for i in 1 .. l_dept.count
  loop
    l_row  := json_object_t();
    l_row.put('DEPTNO',l_dept(i).deptno);
    l_row.put('DNAME',l_dept(i).dname);
    l_row.put('LOC',l_dept(i).loc);

    l_json.put(to_char(i),l_row);
  end loop;
  dbms_output.put_line(l_json.stringify);
end;
/
pause
clear screen

set serverout on
declare
  type dept_list is 
    table of dept%rowtype
    index by pls_integer;
 
  l_dept dept_list;
  l_json json;
begin
  select *
  bulk collect 
  into l_dept
  from dept;
  
  l_json := json(l_dept);
  
  dbms_output.put_line(json_serialize(l_json));
end;
/
pause
clear screen
set serverout on
declare
  type dept_name_list is 
    varray(10) of varchar2(20);
 
  l_dept dept_name_list;
  l_json json;
begin
  select dname
  bulk collect 
  into l_dept
  from dept;
  
  l_json := json(l_dept);
  
  dbms_output.put_line(json_serialize(l_json pretty));
end;
/
pause
clear screen

set serverout on
declare
  cursor c_dept is
    select deptno, dname
    from   dept;
    
  type dept_list is 
    varray(10) of c_dept%rowtype;
 
  l_dept dept_list;
  l_json json;
begin
  open c_dept;
  fetch c_dept
  bulk collect 
  into l_dept;
  close c_dept;
  
  l_json := json(l_dept);
  
  dbms_output.put_line(json_serialize(l_json));
end;
/

pause Done
