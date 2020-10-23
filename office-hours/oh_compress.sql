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
@drop t
set echo on
set termout on
create table t as 
select d.* from dba_objects d,
 ( select 1 from dual connect by level <= 50 );
select count(*) from t; 
pause
select blocks from user_tables
where table_name = 'T';
pause
clear screen

create or replace
procedure ins is
begin
  for i in 1 .. 60 
  loop
     insert into t
       ( object_id, timestamp )
     values (-i, to_char(systimestamp,'hh24:mi:ss.ff'));
     commit;
     dbms_lock.sleep(1);
  end loop;
end;
/
pause
clear screen

variable j number
exec  dbms_job.submit(:j,'begin ins; end;');
commit;
pause
declare
  r int;
begin
  loop
    select count(*) into r
    from   dba_jobs_running
    where  job = :j;
    exit when r > 0;
    dbms_lock.sleep(0.4);
  end loop;
end;
/
pause
clear screen
alter table t move compress online;
pause

select object_id, timestamp
from   t
where  object_id < 0
order by 1 desc;

pause
select blocks from user_tables
where table_name = 'T';
pause
exec dbms_stats.gather_table_stats('','T')
pause

select blocks from user_tables
where table_name = 'T';
