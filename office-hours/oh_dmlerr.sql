REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
@clean
set termout off
@drop chd
@drop par
@drop err$_par
@drop audit_log
col ora_err_mesg$ format a90
col p format a10
set lines 120
set termout on
set echo on
clear screen
create table par ( p int primary key );
create table chd ( c int primary key, p int references par ( p ));
pause
clear screen
insert into par values (1);
insert into par values (2);
insert into par values (3);
pause
insert into chd
select rownum,1 from dual connect by level <= 100;
insert into chd
select rownum+100,2 from dual connect by level <= 100;

commit;
pause

clear screen
delete from par;
pause
clear screen
exec dbms_errlog.create_error_log('PAR')
pause
delete from par
log errors reject limit unlimited;
pause
select p,ora_err_mesg$  from err$_par;
pause
rollback;

pause
clear screen
create table audit_log
  (    mod_type varchar2(10),
       mod_date date,
       parent number);
pause       

create or replace
trigger PAR_TRG
before delete on par
for each row
begin
   insert into audit_log 
   values ('DELETE',sysdate,:old.p);
end;
/
pause
clear screen
truncate table err$_par;
pause
delete from par
log errors reject limit unlimited

pause
/
pause
rollback;
pause
clear screen

create or replace
trigger PAR_TRG
before delete on par
for each row
begin
    null;
end;
/
pause
clear screen
truncate table err$_par;
pause
delete from par
log errors reject limit unlimited;
pause
rollback;
pause

clear screen
create or replace
trigger PAR_TRG
before delete on par
begin
    null;
end;
/
pause
clear screen
truncate table err$_par;
pause
delete from par
log errors reject limit unlimited;
pause
rollback;
pause

clear screen
drop trigger par_trg;
pause

create or replace trigger par_trg
  for delete on par
  compound trigger

  before each row is
  begin
    insert into audit_log 
     values ('DELETE',sysdate,:old.p);
  end before each row;

end;
/
pause
clear screen
truncate table err$_par;
pause
delete from par
log errors reject limit unlimited;
pause
select p,ora_err_mesg$  from err$_par;





