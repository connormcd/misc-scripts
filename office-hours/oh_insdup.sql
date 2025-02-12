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
conn USER/PASSWORD@MY_PDB
set termout off
clear screen
set timing off
set time off
set pages 999
@drop t
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t ( x int  );
pause
insert into t
select rownum*2
from dual
connect by level <= 100000;
commit;
pause
clear screen
select count(*)
from t 
where x = 1001;
pause
insert into t
values (1001);
--
-- over to session 2
--
pause
roll;
pause
clear screen
alter table t add primary key ( x );
pause
set timing on
declare
  c int;
begin
  for i in 1 .. 200000 loop
    select count(*) into c
    from  t 
    where x = i;
    
    if c = 0 then
      insert into t 
      values (i);
    end if;
  end loop;
end;
/
set timing off
pause
clear screen
drop table t purge;
create table t ( x int  );
insert into t
select rownum*2
from dual
connect by level <= 100000;
alter table t add primary key ( x );
pause
clear screen

set timing on
begin
  for i in 1 .. 200000 loop
    begin
      insert into t 
      values (i);
    exception
      when dup_val_on_index then null;
    end;
  end loop;
end;
/
set timing off
pause
clear screen
drop table t purge;
create table t ( x int  );
insert into t
select rownum*2
from dual
connect by level <= 100000;
alter table t add primary key ( x );
pause
clear screen
set timing on
begin
  for i in 1 .. 200000 loop
    insert into t 
    select i from dual
    where not exists ( select 1 from t where x = i );
  end loop;
end;
/
set timing off
pause
clear screen
drop table t purge;
create table t ( x int  );
insert into t
select rownum*2
from dual
connect by level <= 100000;
alter table t add primary key ( x );
pause
clear screen
set timing on
begin
  for i in 1 .. 200000 loop
    merge into t 
    using ( select i n from dual ) m
    on ( m.n = t.x )
    when not matched then
      insert values (m.n );
  end loop;
end;
/
set timing off

pause
clear screen
drop table t purge;
create table t ( x int  );
insert into t
select rownum*2
from dual
connect by level <= 100000;
alter table t add constraint t_pk primary key ( x );
pause
clear screen
set timing on
begin
  for i in 1 .. 200000 loop
      insert /*+ ignore_row_on_dupkey_index(t, t_pk) */ into t 
      values (i*2+1);
  end loop;
end;
/
set timing off

pause
clear screen
drop table t purge;
create table t ( x int  );
insert into t
select rownum*2
from dual
connect by level <= 100000;
alter table t add primary key ( x );
pause
clear screen
set timing on
begin
  for i in 1 .. 200000 loop
    begin
      insert into t 
      values (i*2+1);
    exception
      when dup_val_on_index then null;
    end;
  end loop;
end;
/
set timing off
