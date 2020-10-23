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
clear screen
exec dbms_random.seed(0)
@drop emp
@drop dept
@drop t
@drop t1
@drop t2

create table emp as select * from scott.emp;
create table dept as select * from scott.dept;
alter session set "_gby_hash_aggregation_enabled" = false;

clear screen
set echo on
set termout on
select * from emp;

select count(distinct deptno) from emp;
pause
clear screen

select empno, deptno from emp
order by 2;
pause

clear screen
select 
  empno, 
  deptno,
  case when deptno != nvl(lag(deptno) over (order by deptno),-1) then 1 end newval
from emp
order by deptno;
pause
clear screen
select count(newval)
from 
(
select 
  empno, 
  deptno,
  case when deptno != nvl(lag(deptno) over (order by deptno),-1) then 1 end newval
from emp
);
pause

clear screen
set autotrace traceonly explain
select count(distinct deptno) from emp;
set autotrace off
pause

clear screen
set serverout on  
declare
  type hash_bucket is table of varchar2(1)
    index by pls_integer;
  h hash_bucket;
begin
  for i in ( select * from emp )
  loop
     h(i.deptno) := 'Y';
  end loop;
  dbms_output.put_line('distinct='||h.count);
end;
.

pause
/
pause

alter session set "_gby_hash_aggregation_enabled" = true;
clear screen

set autotrace traceonly explain
select count(distinct deptno) from emp;
pause

clear screen
select count(deptno)
from 
  ( select deptno from emp
    group by deptno )
    
pause
/
set autotrace off
pause

clear screen
create table t as select * from dba_objects where object_id is not null
and owner in ('SYS','SYSTEM','SCOTT','SH');
pause

set autotrace traceonly explain
select owner, count(distinct object_id)
from t
group by owner;
pause
clear screen

select owner, count(object_id)
from (
  select owner, object_id from t 
  group by owner, object_id
)
group by owner;
pause
set autotrace off
/
pause
clear screen
set autotrace traceonly explain
select owner, count(distinct object_id), count(distinct data_object_id)
from t
group by owner

pause
/
set autotrace off
pause
clear screen


set autotrace traceonly explain
select count(distinct object_id), count(distinct data_object_id)
from t;
set autotrace off
pause
clear screen

create table t1 as 
select 
  trunc(dbms_random.value(1,60)) q1,
  trunc(dbms_random.value(1,60)) q2
from dual
connect by level <= 30;
pause

select 
  count(*),
  count(distinct q1),
  count(distinct q2)
from t1;
pause

set echo off
clear screen
pro |     0----+----1----+----2----+----3----+----4----+----5----+----6----|
pro | q1  
pro | q2
pause
set echo on
select q1, q2 from t1 where rownum = 1;
pause
set echo off
clear screen
pro |     0----+----1----+----2----+----3----+----4----+----5----+----6----|
pro | q1                X
pro | q2               X
pause
set echo on
select q1, q2 from t1 where rownum <= 2;
pause
set echo off
clear screen
pro |     0----+----1----+----2----+----3----+----4----+----5----+----6----|
pro | q1                X             X
pro | q2               X                                           X
pause

clear screen
pro |     0----+----1----+----2----+----3----+----4----+----5----+----6----|
pro | q1                X             X       X
pro | q2               X        X                                  X
pause

clear screen
pro |     0----+----1----+----2----+----3----+----4----+----5----+----6----|
pro | q1    X           X             X       X
pro | q2      X        X        X                                  X
pause

clear screen
pro |     0----+----1----+----2----+----3----+----4----+----5----+----6----|
pro | q1    X           X             X       X           X
pro | q2      X        X        X         X                        X
pause



set echo on
clear screen

set serverout on
declare
  bits_q1 varchar2(64) := rpad('0',64,'0');
  bits_q2 varchar2(64) := rpad('0',64,'0');
begin
  for i in ( select * from t1 )
  loop
    bits_q1 := substr(bits_q1,1,i.q1-1)||'1'||substr(bits_q1,i.q1+1);
    bits_q2 := substr(bits_q2,1,i.q2-1)||'1'||substr(bits_q2,i.q2+1);
  end loop;
  dbms_output.put_line('bits_q1='||bits_q1);
  dbms_output.put_line('bits_q2='||bits_q2);
  dbms_output.put_line('ndv_q1='||(length(bits_q1)-length(replace(bits_q1,'1'))));
  dbms_output.put_line('ndv_q2='||(length(bits_q2)-length(replace(bits_q2,'1'))));
end;
.
pause
/
pause
clear screen

set echo off
clear screen
pro |     0----+----1----+----2----+----3----+----4----+----5----+----6----|
pro | q1    X           X             X       X           X
pro | q2      X        X        X         X                        X               X <<==AGGGHH!!!
pause

set echo on
clear screen
create table t2 as 
select 
    300*trunc(dbms_random.value(1,60)) q1,
    500*trunc(dbms_random.value(1,60)) q2 
from dual
connect by level <= 50;
pause

select 
  count(*),
  count(distinct q1),
  count(distinct q2),
  max(q1),
  max(q2)
from t2;
pause
clear screen

set serverout on
declare
  type vc2list is table of varchar2(64)
    index by pls_integer;
  bits_q1 vc2list;
  bkt_q1  int;
  pos  int;
  totndv int := 0;
begin
  for i in ( select * from t2 ) 
  loop
    bkt_q1 := floor(i.q1/64);
    pos := mod(i.q1,64)+1;
    if not bits_q1.exists(bkt_q1) then
      bits_q1(bkt_q1) := rpad('0',64,'0');
    end if;
    bits_q1(bkt_q1) := substr(bits_q1(bkt_q1),1,pos-1)||'1'||substr(bits_q1(bkt_q1),pos+1);
  end loop;
#pause

  bkt_q1 := bits_q1.first;
  loop
    dbms_output.put_line('bucket='||rpad(bkt_q1,5)||':'||bits_q1(bkt_q1));
    totndv := totndv +
                 (length(bits_q1(bkt_q1))-length(replace(bits_q1(bkt_q1),'1')));
    bkt_q1 := bits_q1.next(bkt_q1);
    exit when bkt_q1 is null;
  end loop;
  dbms_output.put_line('totndv='||totndv);
end;
.
pause
/
pause
clear screen

set serverout on
declare
  type vc2list is table of varchar2(64)
    index by pls_integer;
  bits_q1 vc2list;
  bkt_q1  int;
  bits_q2 vc2list;
  bkt_q2  int;
  pos  int;
  totndv_q1 int := 0;
  totndv_q2 int := 0;
begin
  for i in ( select * from t2 ) 
  loop
    bkt_q1 := floor(i.q1/64);
    pos := mod(i.q1,64)+1;
    if not bits_q1.exists(bkt_q1) then
      bits_q1(bkt_q1) := rpad('0',64,'0');
    end if;
    bits_q1(bkt_q1) := substr(bits_q1(bkt_q1),1,pos-1)||'1'||substr(bits_q1(bkt_q1),pos+1);
#pause
    bkt_q2 := floor(i.q2/64);
    pos := mod(i.q2,64)+1;
    if not bits_q2.exists(bkt_q2) then
      bits_q2(bkt_q2) := rpad('0',64,'0');
    end if;
    bits_q2(bkt_q2) := substr(bits_q2(bkt_q2),1,pos-1)||'1'||substr(bits_q2(bkt_q2),pos+1);

  end loop;
  
  bkt_q1 := bits_q1.first;
  loop
    totndv_q1 := totndv_q1 +
                 (length(bits_q1(bkt_q1))-length(replace(bits_q1(bkt_q1),'1')));
    bkt_q1 := bits_q1.next(bkt_q1);
    exit when bkt_q1 is null;
  end loop;
  dbms_output.put_line('totndv_q1='||totndv_q1);
#pause

  bkt_q2 := bits_q2.first;
  loop
    totndv_q2 := totndv_q2 +
                 (length(bits_q2(bkt_q2))-length(replace(bits_q2(bkt_q2),'1')));
    bkt_q2 := bits_q2.next(bkt_q2);
    exit when bkt_q2 is null;
  end loop;
  dbms_output.put_line('totndv_q2='||totndv_q2);

end;
.
pause
/
pause
clear screen

select 
  bitmap_bucket_number(q1),
  bitmap_construct_agg(q1)
from t2
group by bitmap_bucket_number(q1);
pause

clear screen
select bitmap_count(bitmap_or_agg(bits))
from 
(
  select 
    bitmap_bucket_number(q1),
    bitmap_construct_agg(q1) bits
  from t2
  group by bitmap_bucket_number(q1)
)

pause
/
pause
clear screen


select 
  bitmap_count(bitmap_or_agg(bits_q1)) ndv_q1,
  bitmap_count(bitmap_or_agg(bits_q2)) ndv_q2
from 
(
  select 
    bitmap_bucket_number(q1),
    bitmap_bucket_number(q2),
    bitmap_construct_agg(q1) bits_q1,
    bitmap_construct_agg(q2) bits_q2
  from t2
  group by 
    bitmap_bucket_number(q1),
    bitmap_bucket_number(q2)
)

pause
/



