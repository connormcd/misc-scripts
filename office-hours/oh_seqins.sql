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
exec dbms_random.seed(0)
@drop contacts
@drop new_contacts
@drop contact_seq

col first_name format a12
col last_name format a12
col phone_number format a12
col mobile format a12
col emergency format a12
col home format a12

create table contacts as
select 
   employee_id emp_id
  ,first_name
  ,last_name
  ,phone_number
  ,'04'||to_char(mod(rownum,20),'FM00')||' '||trunc(dbms_random.value(100000,999999)) mobile
  ,'04'||to_char(mod(rownum,20),'FM00')||' '||trunc(dbms_random.value(100000,999999)) emergency
  ,'652.'||trunc(dbms_random.value(100,999))||'.'||trunc(dbms_random.value(1000,9909)) home
from hr.employees
where rownum <= 10;

@clean
set lines 60
set echo on
desc contacts
set lines 120
pause
select * from contacts;
pause
clear screen

select 
   emp_id
  ,first_name
  ,last_name
  ,'Work' contact_type
  ,phone_number
from contacts
#pause
union all
select 
   emp_id
  ,first_name
  ,last_name
  ,'Mobile' contact_type
  ,mobile
from contacts
#pause
union all
select 
   emp_id
  ,first_name
  ,last_name
  ,'Emer' contact_type
  ,emergency
from contacts
#pause
union all
select 
   emp_id
  ,first_name
  ,last_name
  ,'Home' contact_type
  ,home
from contacts
order by 1,4

pause
/
pause
clear screen

create table new_contacts
(
   contact_pk             number(6)
  ,emp_id                 number(6)
  ,first_name             varchar2(20)
  ,last_name              varchar2(25)
  ,contact_type           varchar2(6)  -- Work, Home, Mobile, etc
  ,phone_number           varchar2(20)       
);
pause

alter table new_contacts
  add constraint new_contacts_pk
  primary key ( contact_pk );

create sequence contact_seq;
pause

clear screen
insert all
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Work',phone_number)
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Emer',mobile)
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Mobile',emergency)
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Home',home)
select * 
from contacts

pause
/
pause

clear screen
alter table new_contacts
  drop constraint new_contacts_pk;
pause
insert all
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Work',phone_number)
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Emer',mobile)
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Mobile',emergency)
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Home',home)
select * 
from contacts;
pause

clear screen
select * from new_contacts
order by 1;
pause
clear screen
select 
  emp_id,
  first_name,
  last_name,
  contact_type,
  phone_number
from   contacts
unpivot (
  phone_number 
    for contact_type in 
      (phone_number AS 'Work', 
       mobile AS 'Mobile', 
       emergency AS 'Emer', 
       home AS 'Home'))

pause
/
pause

clear screen
truncate table new_contacts;

alter table new_contacts
  add constraint new_contacts_pk
  primary key ( contact_pk );
pause

insert into new_contacts
select 
  contact_seq.nextval,
  emp_id,
  first_name,
  last_name,
  contact_type,
  phone_number
from   contacts
unpivot (
  phone_number 
    for contact_type in 
      (phone_number AS 'Work', 
       mobile AS 'Mobile', 
       emergency AS 'Emer', 
       home AS 'Home'));
pause
clear screen
truncate table new_contacts;
pause

alter sequence contact_seq increment by 10;
pause


insert all
  into new_contacts 
  values (contact_seq.nextval,
          emp_id,first_name,last_name,'Work',phone_number)
  into new_contacts 
  values (contact_seq.nextval+1,
          emp_id,first_name,last_name,'Emer',mobile)
  into new_contacts 
  values (contact_seq.nextval+2,
          emp_id,first_name,last_name,'Mobile',emergency)
  into new_contacts 
  values (contact_seq.nextval+3,
          emp_id,first_name,last_name,'Home',home)
select * 
from contacts;
pause
clear screen

select * from new_contacts
order by 1;


