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
@drop t1
@dropc t2
set lines 200
set termout on
clear screen
set feedback on
set echo on
create table t as 
select * from dba_objects 
where 1=0;
pause
create table t1 as 
select d.* from dba_objects d,
  ( select 1 from dual 
    connect by level <= 20 );
pause    
select num_rows
from   user_tables
where  table_name = 'T1';
pause
clear screen
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
  
begin
  select * bulk collect into r
  from t1;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert into t values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);    
end;
/
pause
set termout off
clear screen
@drop t
clear screen
set termout on
create table t as 
select * from dba_objects 
where 1=0;
pause    
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
begin
  select * bulk collect into r
  from t1;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert /*+ APPEND_VALUES */ into t values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);    
end;
/
pause
set termout off
clear screen
@drop t
clear screen
set termout on
create table t as 
select * from dba_objects 
where 1=0;
pause    
set timing on
insert into t select * from t1;
set timing off
commit;
pause
truncate table t;
pause
set timing on
insert /*+ APPEND */ into t select * from t1;
set timing off
commit;
pause
clear screen
alter table t nologging;
pause
truncate table t;
pause
set timing on
insert /*+ APPEND */ into t select * from t1;
set timing off
commit;
pause
clear screen
alter table t logging;
truncate table t;
pause
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
  
begin
  select * bulk collect into r
  from t1;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert into t values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);    
end;
/
pause
clear screen
alter table t nologging;
truncate table t;
pause
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
  
begin
  select * bulk collect into r
  from t1;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert /*+ APPEND_VALUES */ into t values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);    
end;
/
pause
clear screen
select count(*) from t1;
pause
create table t2 as select * from t1;
pause
create index t2ix1 on t2 ( owner );
create index t2ix2 on t2 ( object_id);
create index t2ix3 on t2 ( object_name);
pause
clear screen
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
  
begin
  select * bulk collect into r
  from t1
  where rownum <= 800000;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert into t2 values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);    
  commit;
end;
/
pause
clear screen
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
  
begin
  select * bulk collect into r
  from t1
  where rownum <= 800000;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert /*+ APPEND_VALUES */ into t2 values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);   
  commit;
end;
/
pause
set termout off
clear screen
@drop t2
clear screen
set termout on
create table t2 as select * from t1;
pause
create index t2ix1 on t2 ( owner );
create index t2ix2 on t2 ( object_id);
create index t2ix3 on t2 ( object_name);
pause
delete from t2 where mod(object_id,2) = 0 ;
commit;
pause
clear screen
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
  
begin
  select * bulk collect into r
  from t1
  where rownum <= 800000;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert into t2 values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);    
  commit;
end;
/
pause
clear screen
set serverout on
declare
  type rlist is table of t%rowtype 
    index by pls_integer;
  r rlist;
  s1 timestamp;
  s2 timestamp;
  
begin
  select * bulk collect into r
  from t1
  where rownum <= 800000;
  
  s1 := localtimestamp;
  forall i in 1 .. r.count
    insert /*+ APPEND_VALUES */ into t2 values r(i);
  s2 := localtimestamp;
  dbms_output.put_line(s2-s1);   
  commit;
end;
/
