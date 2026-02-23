clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
@drop credit_card
drop domain amex ;
drop domain bigcase;
@drop emp_contractors
drop domain emp_contract;
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
create sequence seq;
clear screen
set termout on
set echo off
prompt |   
prompt |     ____   ___  __  __    _    ___ _   _ 
prompt |    |  _ \ / _ \|  \/  |  / \  |_ _| \ | |
prompt |    | | | | | | | |\/| | / _ \  | ||  \| |
prompt |    | |_| | |_| | |  | |/ ___ \ | || |\  |
prompt |    |____/ \___/|_|  |_/_/   \_\___|_| \_|
prompt |                                          
prompt |
pause
set echo on
clear screen

set termout on
set echo on
create domain amex as varchar2(15)
constraint amex_chk check ( regexp_like(amex,'^3[47][0-9]{13}$'))
display '****'||substr(amex,-4,4);
pause
create table credit_card 
  ( cc varchar2(15) domain amex );
pause
clear screen
insert into credit_card values ('4324245');
pause
insert into credit_card values ('312391234567890');
pause
insert into credit_card values ('347991234567890');
pause
clear screen
select * from credit_card;
pause
select domain_display(cc) from credit_card;
pause
clear screen
select domain_check(AMEX,'312391234567890');
pause
select domain_check(AMEX,'347991234567890');
pause
clear screen
create domain bigcase as varchar2(10)
constraint bigcase_chk check ( bigcase = upper(bigcase));
pause
select domain_check(BIGCASE,'hellothere');
pause
select domain_check(BIGCASE,'HELLOTHERE');
pause
select domain_check(BIGCASE,'HELLOEVERYONE');
pause
select domain_check(BIGCASE,'HELLO');
pause
set echo off
--select domain_check(BIGCASE,cast('HELLO' as varchar2(10)));
--pause
--select domain_check(BIGCASE,cast('HELLO' as bigcase));
--pause
set echo on
clear screen
create domain emp_contract as (
  commencement as date,
  termination  as date )
  constraint emp_contract_chk1 check ( commencement > date '2023-01-01' )
  constraint emp_contract_chk2 check ( termination > commencement );  
pause
create table emp_contractors
 (   eid   number,
     hire_date date,
     fire_date date,
     domain emp_contract(hire_date, fire_date)
 );
pause Done