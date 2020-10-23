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
conn USER/PASSWORD@MY_DB
set termout off
@drop parent
@drop child
@drop grandchild

@drop parent_seq
@drop child_seq
set termout on
@clean
set echo on

create table parent ( 
  p int constraint P_PK primary key , 
  pdescr varchar2(10));
pause
create table child ( 
  c int constraint C_PK primary key, 
  p int , 
  cdescr varchar2(10),
  constraint FK foreign key ( p ) references parent ( p ) 
  );
pause
create sequence parent_seq;
create sequence child_seq;
pause

clear screen
insert all
when r=1 then
  into parent (p,pdescr) values (parent_seq.nextval,'abc')
when r>1 then  
  into child (c,p,cdescr) values (child_seq.nextval,parent_seq.currval,'def')
select rownum r 
from dual
connect by level <= 10

pause
/
pause
clear screen
insert all
when r=1 then
  into parent (p,pdescr) values (1,'abc')
when r>1 then  
  into child (c,p,cdescr) values (r,1,'def')
select rownum r 
from dual
connect by level <= 10

pause
/
pause
clear screen
roll;
pause

insert all
when r=1 then
  into parent (p,pdescr) values (pid,'abc')
when r>1 then  
  into child (c,p,cdescr) values (r,pid,'def')
select rownum r , 1 pid
from dual
connect by level <= 10

pause
/
pause

clear screen
roll;
pause

insert all
when r=1 then
  into parent (p,pdescr) values (pid,'abc')
when r>1 then  
  into child (c,p,cdescr) values (r,pid,'def')
select 11-rownum r , 1 pid
from dual
connect by level <= 10

pause
/
pause
clear screen
roll;
pause

insert all
when r=10 then
  into parent (p,pdescr) values (pid,'abc')
when r<10 then  
  into child (c,p,cdescr) values (r,pid,'def')
select rownum r , 1 pid
from dual
connect by level <= 10

pause
/
pause
clear screen
roll;
pause

alter table child modify constraint FK disable;
pause
drop sequence parent_seq;
drop sequence child_seq;

create sequence parent_seq;
create sequence child_seq;
pause
clear screen

insert all
when r=1 then
  into parent (p,pdescr) values (parent_seq.nextval,'abc')
when r>1 then  
  into child (c,p,cdescr) values (child_seq.nextval,parent_seq.currval,'def')
select rownum r 
from dual
connect by level <= 10;
pause

clear screen
select * from parent;
pause
select * from child;
pause


clear screen
roll;
pause


insert all
when 1=1 then
  into parent (p,pdescr) values (parent_seq.nextval,'abc')
when 1=1 then
  into parent (p,pdescr) values (parent_seq.nextval,'efg')
select rownum r 
from dual
connect by level <= 10

pause
/
pause
clear screen


set echo off
set termout off
@drop parent
@drop child
@drop grandchild

clear screen
set termout on
pro
pro .   ______   _______      _        _______ _________     _______  _       
pro .  (  __  \ (  ___  )    ( (    /|(  ___  )\__   __/    (  ____ \| \    /\
pro .  | |  (  \| (   ) |    |  \  ( || (   ) |   ) (       | (    \/|  \  / /
pro .  | |   ) || |   | |    |   \ | || |   | |   | |       | (__    |  (_/ / 
pro .  | |   | || |   | |    | (\ \) || |   | |   | |       |  __)   |   _ (  
pro .  | |   ) || |   | |    | | \   || |   | |   | |       | (      |  ( \ \ 
pro .  | (__/  )| (___) |    | )  \  || (___) |   | |       | )      |  /  \ \
pro .  (______/ (_______)    |/    )_)(_______)   )_(       |/       |_/    \/
pro .
set echo on
pause
clear screen
create table parent(
  pk      number,
  descr        varchar2(10),
  descr_big    varchar2(300),
  constraint ptab_pk primary key(pk)
);
pause

create table child(
  pk      number,
  descr_big    varchar2(300),
  constraint chld_pk primary key(pk),
  constraint chld_fk_par foreign key (pk) references parent(pk)
);
pause

create table grandchild(
  pk      number,
  descr_big    varchar2(300),
  constraint ch2_pk primary key(pk),
  constraint ch2_fk_par foreign key (pk) references child(pk)
);
pause
clear screen

insert all
  into parent    (pk, descr)     values(pk, descr)
  into child     (pk, descr_big) values(pk, descr_big)
  into grandchild(pk, descr_big) values(pk, descr_big)
select rownum             pk,
   lpad(rownum,10,'0')    descr,
   lpad(rownum,300,'0')   descr_big
from dual connect by level <= 10

pause
/
pause
roll;
pause
clear screen

insert all
  into parent    (pk, descr)     values(pk, descr)
  into child     (pk, descr_big) values(pk, descr_big)
  into grandchild(pk, descr_big) values(pk, descr_big)
select rownum             pk,
   lpad(rownum,10,'0')    descr,
   lpad(rownum,300,'0')   descr_big
from dual connect by level <= 100

pause
/

