REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@dropc t

create table t as
select * from dba_objects
where instr(object_name,'_') = 0
and instr(object_name,'.') = 0
and instr(object_name,'\') = 0
and instr(object_name,'/') = 0
and instr(object_name,'$') = 0
and rownum <= 1000;

create index ix on t ( object_name )
indextype is ctxsys.context
parameters ('sync (on commit)');

select count(*)
from t
where contains(object_name,'ASTEXT',1) > 0;


select count(*) from DR$IX$B;
select count(*) from DR$IX$C;
select count(*) from DR$IX$I;
select count(*) from DR$IX$K;
select count(*) from DR$IX$N;
select count(*) from DR$IX$Q;
select count(*) from DR$IX$U;

update t
set owner = lower(owner)
where rownum <= 1000;

select count(*) from DR$IX$B;
select count(*) from DR$IX$C;
select count(*) from DR$IX$I;
select count(*) from DR$IX$K;
select count(*) from DR$IX$N;
select count(*) from DR$IX$Q;
select count(*) from DR$IX$U;

update t
set object_name = lower(object_name)
where rownum <= 1000;

select count(*) from DR$IX$B;
select count(*) from DR$IX$C;
select count(*) from DR$IX$I;
select count(*) from DR$IX$K;
select count(*) from DR$IX$N;
select count(*) from DR$IX$Q;
select count(*) from DR$IX$U;

commit;

select count(*) from DR$IX$B;
select count(*) from DR$IX$C;
select count(*) from DR$IX$I;
select count(*) from DR$IX$K;
select count(*) from DR$IX$N;
select count(*) from DR$IX$Q;
select count(*) from DR$IX$U;

exec ctx_ddl.sync_index('IX');

select count(*) from DR$IX$B;
select count(*) from DR$IX$C;
select count(*) from DR$IX$I;
select count(*) from DR$IX$K;
select count(*) from DR$IX$N;
select count(*) from DR$IX$Q;
select count(*) from DR$IX$U;

select count(*)
from t
where contains(object_name,'astext',99) > 0;

select count(*)
from t
where contains(object_name,'ASTEXT',99) > 0;


select count(*)
from t
where object_name = 'astext';

create or replace
trigger t_trg
before update on t
for each row
begin
--  :new.object_name := :new.object_name||'x' ;
  :new.object_name := :new.object_name ;
end;
/

update t
set owner = lower(owner);

select count(*) from DR$IX$B;
select count(*) from DR$IX$C;
select count(*) from DR$IX$I;
select count(*) from DR$IX$K;
select count(*) from DR$IX$N;
select count(*) from DR$IX$Q;
select count(*) from DR$IX$U;

commit;

select count(*) from DR$IX$B;
select count(*) from DR$IX$C;
select count(*) from DR$IX$I;
select count(*) from DR$IX$K;
select count(*) from DR$IX$N;
select count(*) from DR$IX$Q;
select count(*) from DR$IX$U;


select count(*)
from t
where contains(object_name,'astext',99) > 0;

select count(*)
from t
where contains(object_name,'astextx',99) > 0;


