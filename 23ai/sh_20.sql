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
prompt |      _ ____   ___  _   _   __      ___  ____      _ _____ ____ _____ 
prompt |     | / ___| / _ \| \ | |  \ \    / _ \| __ )    | | ____/ ___|_   _|
prompt |  _  | \___ \| | | |  \| |   \ \  | | | |  _ \ _  | |  _|| |     | |  
prompt | | |_| |___) | |_| | |\  |   / /  | |_| | |_) | |_| | |__| |___  | |  
prompt |  \___/|____/ \___/|_| \_|  /_/    \___/|____/ \___/|_____\____| |_|  
prompt |                                                                    
pause
set echo on
clear screen

set echo on
set termout on

create table dept_doc ( j json);
pause
insert into dept_doc
values ( '{"DEPTNO":20,"DNAME":"RESEARCH","LOC":"DALLAS"}');
commit;
pause
create or replace
type dept_row as object
( deptno number,
  dname  varchar2(20),
  loc    varchar2(10)
);
/
pause
clear screen
set serverout on
declare
  l_row dept_row;
begin  
  select json_value(j, '$' returning dept_row)
  into   l_row
  from   dept_doc;
  
  dbms_output.put_line(l_row.deptno||','||
                       l_row.dname||','||
                       l_row.loc);
end;
/
pause
clear screen
insert into dept_doc
values ( '{"DEPTNO":10,"DNAME":"ACCOUNTING","LOC":"NEW YORK"}');

insert into dept_doc
values ( '{"DEPTNO":30,"DNAME":"SALES","LOC":"CHICAGO"}');

insert into dept_doc
values ( '{"DEPTNO":40,"DNAME":"OPERATIONS","LOC":"BOSTON"}');
pause
clear screen
set serverout on
declare 
  type multi_row is table of dept_row
    index by pls_integer;
  l_row multi_row;
begin  
  select json_value(j, '$' returning dept_row)
  bulk collect 
  into   l_row
  from   dept_doc;
  
  for i in 1 .. l_row.count
  loop
    dbms_output.put_line(l_row(i).deptno||','||
                         l_row(i).dname||','||
                         l_row(i).loc);
  end loop;
end;
/

pause Done
