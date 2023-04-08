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
set termout off
alter session set nls_date_format = 'DD-MON-RR';
alter session set cursor_sharing = exact;
alter session disable parallel dml;
set markup csv off
set markup html off
set autotrace off
set timing off
set sqlprompt 'SQL> '
set echo off
set feedback on
clear screen
set heading on
set termout on
set define '&'
set tab off
set long 50000
set longchunksize 500
set pages 999
undefine 1
undefine 2
undefine 3
undefine 4

set termout off
conn ADMIN_USER/PASSWORD@MY_DB
set termout off
alter system set max_columns = standard;
alter session set group_by_position_enabled = false;
drop table person cascade constraints purge;
drop sequence seq;
create sequence seq;
clear screen

set echo on
set termout on
create table person (
  pid     int,
  married varchar2(1));
pause
drop table person purge;
create table person (
  pid     int,
  married boolean);
pause
insert into person values (1,true);
pause
insert into person values (2,false);
pause
insert into person values (3,'Y');
pause
insert into person values (4,'Yes');
pause
insert into person values (5,1);
pause
insert into person values (6,0);
pause
insert into person values (7,100);
pause
select * from person;
pause

clear screen
drop table person purge;
create table person (
  pid     int,
  married varchar2(1));
pause
alter table person modify married boolean;
pause
clear screen
drop table person purge;
create table person (
  pid     int,
  married varchar2(1));
pause
insert into person values (1,'Y');
pause
alter table person modify married boolean;
pause
clear screen
alter table person add married_bool boolean;
pause
update person 
set married_bool = to_boolean(married);
pause
alter table person set unused column married;
pause
alter table person rename column married_bool to married;
pause
set lines 60
desc person 
set lines 100
pause
clear screen
select *
from person
where married = true;
pause
select *
from person
where married;
pause
clear screen
select *
from person
where married 
 or pid = 2;
pause
select 
  case when married then 'Married' 
       else 'Not Married' 
  end
from person;  
pause
clear screen
create index person_bool_ix 
on person ( married );
pause
alter table person
add constraint person_chk check
 ( married or pid != 0 );
 