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
@clean
set termout off
conn USERNAME/PASSWORD@SERVICE_NAME
set termout off
drop index scott.scott_search_idx force;
exec ctxsys.ctx_ddl.drop_preference('SCOTT.SEARCH_IDX_DST');
alter table scott.dept drop column js;
drop trigger scott.dept_tickle_the_index ;
drop trigger scott.emp_tickle_the_index ;
drop package scott.in_trigger;
set termout on
clear screen
set echo on
select * from scott.dept;
pause
create index scott.scott_search_idx on scott.dept(dname)
  indextype is ctxsys.context
/
pause
select * from scott.dept
where contains(dname,'RESEARCH',99) > 0;
pause
select * from scott.dept
where contains(dname,'DALLAS',99) > 0;
pause
clear screen
create or replace  
procedure  scott.get_details
(rid in rowid, tlob in out nocopy clob) is
begin
  for i in (select  e.*, d.dname, d.loc
               from scott.emp e,
                    scott.dept d
              where d.rowid = rid
              and   d.deptno = e.deptno
              )
  loop
      tlob := tlob||' '|| i.deptno||' '||i.dname||' '||i.loc||
                    ' '||i.empno||' '||i.empno||' '||i.ename||
                    ' '||i.job||' '||i.mgr;
  end loop;
end;
/
sho err
pause
clear screen
begin
  ctxsys.ctx_ddl.create_preference('SCOTT.SEARCH_IDX_DST','USER_DATASTORE');
  ctxsys.ctx_ddl.set_attribute('SCOTT.SEARCH_IDX_DST','PROCEDURE','SCOTT.GET_DETAILS');
end;
/
pause
drop index scott.scott_search_idx force;
pause
create index scott.scott_search_idx on scott.dept(loc)
  indextype is ctxsys.context
  parameters('sync (on commit) datastore SEARCH_IDX_DST')
/
pause
clear screen
select * from scott.dept;
pause
select * from scott.dept
where contains(loc,'DALLAS',99) > 0;
pause
select * from scott.dept
where loc like '%DALLAS%';
pause
clear screen
select * from scott.dept;
select * from scott.dept
where contains(loc,'SALES',99) > 0;
pause
clear screen
select * from scott.dept;
select * from scott.dept
where contains(loc,'CLERK',99) > 0;
pause
select * from scott.emp
where job = 'CLERK';
pause
clear screen
select * from scott.dept
where contains(loc,'7369',99) > 0;
pause
select * from scott.emp
where empno = 7369;
pause
clear screen
update scott.dept
set loc = 'MEXICO'
where deptno = 20;
commit;
pause
select * from scott.dept
where contains(loc,'MEXICO',99) > 0;
pause
clear screen
select * from scott.dept;
update scott.dept
set DNAME = 'LAB WORK'
where deptno = 20;
commit;
pause
select * from scott.dept
where contains(loc,'LAB',99) > 0;
pause
alter index scott.scott_search_idx rebuild;
pause
select * from scott.dept
where contains(loc,'LAB',99) > 0;
pause
clear screen
update scott.dept
set LOC = 'DALLAS', dname = 'RESEARCH'
where deptno = 20;
commit;
pause
select * from scott.dept
where contains(loc,'LAB',99) > 0;
pause
update scott.dept
set DNAME = 'LAB WORK', loc=loc
where deptno = 20;
commit;
pause
select * from scott.dept
where contains(loc,'LAB',99) > 0;
pause
clear screen
update scott.dept
set LOC = 'DALLAS', dname = 'RESEARCH'
where deptno = 20;
commit;
clear screen
create or replace
trigger scott.dept_tickle_the_index 
after update on scott.dept
for each row
begin
    update scott.dept
    set  loc = loc
    where deptno in ( :old.deptno, :new.deptno);
end;
/
pause
update scott.dept
set DNAME = 'LAB WORK'
where deptno = 20;
commit;
pause
clear screen
create or replace
trigger scott.dept_tickle_the_index 
for update on scott.dept
compound trigger
  g_deptno sys.odcinumberlist := sys.odcinumberlist();
  
  before each row is
  begin 
    g_deptno.extend;
    g_deptno(g_deptno.count) := :old.deptno;
    g_deptno.extend;
    g_deptno(g_deptno.count) := :new.deptno;
  end before each row;

  after statement is
  begin
    update scott.dept
    set  loc = loc
    where deptno in ( select distinct column_value 
                      from table(g_deptno)
                    );
  end after statement;  
end;
/
pause
clear screen
update scott.dept
set DNAME = 'LAB WORK'
where deptno = 20

pause
/
pause
clear screen
create or replace package scott.in_trigger is
  already_here boolean := false;
end;
/
pause
create or replace
trigger scott.dept_tickle_the_index 
for update on scott.dept
compound trigger
  g_deptno sys.odcinumberlist := sys.odcinumberlist();
  
  before each row is
  begin 
    if not scott.in_trigger.already_here then
        g_deptno.extend;
        g_deptno(g_deptno.count) := :old.deptno;
        g_deptno.extend;
        g_deptno(g_deptno.count) := :new.deptno;
    end if;
  end before each row;

  after statement is
  begin
    if not scott.in_trigger.already_here then
      scott.in_trigger.already_here := true;
      update scott.dept
      set  loc = loc
      where deptno in ( select distinct column_value 
                        from table(g_deptno)
                      );
      scott.in_trigger.already_here := true;
    end if;
  end after statement;  
end;
/
pause
clear screen
update scott.dept
set DNAME = 'LAB WORK'
where deptno = 20;
commit;
pause
select * from scott.dept
where contains(loc,'LAB',99) > 0;
pause
clear screen
update scott.dept
set LOC = 'DALLAS', dname = 'RESEARCH'
where deptno = 20;
commit;
pause
clear screen
insert into scott.emp (empno,ename,deptno)
values (1234,'CONNOR',10);
commit;
pause
select * from scott.dept
where contains(loc,'CONNOR',99) > 0;
pause
delete from scott.emp where empno = 1234;
commit;
pause
clear screen
create or replace
trigger scott.emp_tickle_the_index 
for update or insert or delete on scott.emp
compound trigger
  g_deptno sys.odcinumberlist := sys.odcinumberlist();

  before each row is
  begin
    if deleting or updating then
      g_deptno.extend;
      g_deptno(g_deptno.count) := :old.deptno;
    end if;
    
    if updating or inserting then
      g_deptno.extend;
      g_deptno(g_deptno.count) := :new.deptno;
    end if;
  end before each row;

  after statement is
  begin
    scott.in_trigger.already_here := true;
    update scott.dept
    set  loc = loc
    where deptno in ( select distinct column_value 
                      from table(g_deptno)
                    );
    scott.in_trigger.already_here := false;
  end after statement;  
end;
/
pause
clear screen
insert into scott.emp (empno,ename,deptno)
values (1234,'CONNOR',10);
commit;
pause
select * from scott.dept
where contains(loc,'CONNOR',99) > 0;
pause
clear screen
drop index scott.scott_search_idx force;
delete from scott.emp where empno = 1234;
commit;
pause
clear screen
create or replace  
procedure  scott.get_details
(rid in rowid, tlob in out nocopy clob) is
begin
  select  json_arrayagg(json_object(*))
  into    tlob
  from    scott.emp e,
          scott.dept d
  where   d.rowid = rid
  and     d.deptno = e.deptno;
end;
/
pause
clear screen
create search index scott.scott_search_idx 
on scott.dept (loc) for json 
parameters('sync (on commit) datastore SEARCH_IDX_DST');
pause
drop index scott.scott_search_idx force;
pause
clear screen
alter table scott.dept add js varchar2(10); 
pause
alter table scott.dept add constraint js_chk check ( js is json);
pause
create search index scott.scott_search_idx 
on scott.dept (js) for json 
parameters('sync (on commit) datastore SEARCH_IDX_DST');
pause
alter table scott.dept modify js invisible;
pause
clear screen
select * from scott.dept 
where json_textcontains(js, '$', '7369');
pause
select * from scott.dept 
where json_textcontains(js, '$.EMPNO', '7369');
pause
select * from scott.dept 
where json_textcontains(js, '$.ENAME', '7369');
pause
rem
rem cleanup
rem
drop index scott.scott_search_idx force;
alter table scott.dept drop column js;
drop trigger scott.dept_tickle_the_index ;
drop trigger scott.emp_tickle_the_index ;
drop package scott.in_trigger;
drop procedure  scott.get_details;
