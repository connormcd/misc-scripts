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
@drop parent
@drop child
@drop parent_seq
@drop child_seq
set termout on
@clean
set echo on

create table parent ( 
  p int primary key , 
  descr varchar2(10), 
  created date, 
  updated date);
pause
create table child ( 
  c int primary key, 
  p int references parent ( p ) , 
  descr varchar2(10), 
  created date, 
  updated date);
pause
create index child_ix on child ( p );
pause
create sequence parent_seq;
create sequence child_seq;
pause
clear screen

insert into parent 
values (parent_seq.nextval,'parent',sysdate,null);

insert into child 
values (child_seq.nextval,parent_seq.currval,'child',sysdate,null);
commit;
pause
clear screen

update parent
set descr = 'new data'
where p = 1;
pause
select locked_mode, object_name
from v$locked_object l, all_objects ob
where ob.object_id =l.object_id;
pause
clear screen

create or replace
trigger parent_trg
before insert or update
on parent
for each row
begin
  if inserting then
     :new.p := parent_seq.nextval;
     :new.created := sysdate;
  end if;

  if updating then
   :new.updated := sysdate;
  end if;
end;
/
pause
clear screen
create or replace
trigger child_trg
before insert or update
on child
for each row
begin
  if inserting then
     :new.c := child_seq.nextval;
     :new.created := sysdate;
  end if;
  if updating then
     :new.updated := sysdate;
  end if;
end;
/
pause
clear screen

insert into parent (descr) values ('parent');
insert into child (p,descr) values (parent_seq.currval,'child');
commit;
pause
clear screen

update parent
set descr = 'new data'
where p = 2;
pause

select locked_mode, object_name
from v$locked_object l, all_objects ob
where ob.object_id =l.object_id;
pause
clear screen

rollback;
pause
set echo off
clear screen
pro
pro THE WHY ........
pro
pause
pro | create or replace
pro | trigger parent_trg
pro | before insert or update
pro | on parent
pro | for each row
pro | begin
pro |   if inserting then
pro |      :new.p := parent_seq.nextval;  <====== !!!!!
pro |      :new.created := sysdate;
pro |   end if;
pro | 
pro |   if updating then
pro |    :new.updated := sysdate;
pro |   end if;
pro | end;
pause
clear screen
pro | begin
pro |   if inserting and 
pro |      to_char(sysdate,'DD') = '12' and 
pro |      my_function = 10 and
pro |       ... blah blah blah ...
pro |   then
pro |      :new.p := parent_seq.nextval; 
pro |   end if;
pause

set echo on
clear screen



drop trigger parent_trg;

create or replace
trigger parent_trg_ins
BEFORE INSERT
on parent
for each row
begin
      :new.p := parent_seq.nextval;
      :new.created := sysdate;
end;
/
pause

create or replace
trigger parent_trg_upd
BEFORE UPDATE
on parent
for each row
begin
  :new.updated := sysdate;
end;
/
pause
clear screen

update parent
set descr = 'new data'
where p = 2;

select locked_mode, object_name
from v$locked_object l, all_objects ob
where ob.object_id =l.object_id;
pause
clear screen

drop trigger parent_trg_ins;
pause
alter table parent modify p default on null parent_seq.nextval;
pause
alter table parent modify created default on null sysdate;
pause
clear screen
insert into parent (descr) values ('parent');
insert into child (p,descr) values (parent_seq.currval,'child');
commit;
select * from parent;

