clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
drop domain amex ;
@drop credit_card
@drop emp2
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
create table myemp ( empno int, ename varchar2(10));
insert into myemp
values 
  (1,'JOHN'),
  (2,'SUE'),
  (3,'MARY'),
  (4,'JANE'),
  (5,'PETE');
commit;  
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |  ____  _____ _____ _   _ ____  _   _ ___ _   _  ____ 
prompt | |  _ \| ____|_   _| | | |  _ \| \ | |_ _| \ | |/ ___|
prompt | | |_) |  _|   | | | | | | |_) |  \| || ||  \| | |  _ 
prompt | |  _ <| |___  | | | |_| |  _ <| |\  || || |\  | |_| |
prompt | |_| \_\_____| |_|  \___/|_| \_\_| \_|___|_| \_|\____|
prompt |                                                      
prompt |
pause
set echo on
clear screen

set echo on
set termout on

select * from myemp;
pause
clear screen
variable newval varchar2(10);

update myemp
set ename = 'CONNOR'
where empno = 3
returning ename into :newval;
pause
print newval
pause
roll;
pause
clear screen
variable oldval varchar2(10);
update myemp
set ename = 'CONNOR'
where empno = 3
returning old ename, new ename
into :oldval, :newval;
pause
print newval
print oldval
pause
roll;
pause Done

