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
@drop t
@drop t_lookup
variable key number
variable pardate varchar2(30)
col high_value format a30 trunc
set lines 200
alter session set "_fast_index_maintenance" = false;

--@drop tmp
--create table tmp as select * from dba_objects;
--@drop t_par
--create table T_PAR tablespace largets
--partition by range ( par_date )
--interval ( numtodsinterval(14,'DAY'))
--( 
--  partition p1 values less than ( date '2024-05-01' ),
--  partition p2 values less than ( date '2024-05-15' ),
--  partition p3 values less than ( date '2024-05-31' ),
--  partition p4 values less than ( date '2024-06-15' ),
--  partition p5 values less than ( date '2024-06-30' ),
--  partition p6 values less than ( date '2024-07-15' ),
--  partition p7 values less than ( date '2024-07-31' )
--) as 
--select rownum pk, 
--       date '2024-04-20' + trunc(rownum/370000) par_date,
--       d.*
--from tmp d,
--  ( select 1 from dual
--    connect by level <= 400 );
--alter table t_par modify pk not null;
--alter table t_par modify par_date not null;
--exec dbms_stats.gather_table_stats('','T_PAR')
--@drop tmp

set termout on
clear screen
set feedback on
set echo on
--
-- Prepared earlier
--
-- create table T_PAR 
-- partition by range ( par_date )
-- interval ( numtodsinterval(14,'DAY'))
-- ( 
--   partition p1 values less than ( date '2024-05-01' ),
--   partition p2 values less than ( date '2024-05-15' ),
--   partition p3 values less than ( date '2024-05-31' ),
--   partition p4 values less than ( date '2024-06-15' ),
--   partition p5 values less than ( date '2024-06-30' ),
--   partition p6 values less than ( date '2024-07-15' ),
--   partition p7 values less than ( date '2024-07-31' )
-- ) as 
-- select rownum pk, 
--        date '2024-04-20' + trunc(rownum/370000) par_date,
--        d.*
-- from dba_objects d,
--   ( select 1 from dual
--     connect by level <= 400 );
-- 
-- exec dbms_stats.gather_table_stats('','T_PAR')
-- 
pause
clear screen
select num_rows
from user_tables
where table_name = 'T_PAR';
select partition_name, num_rows, high_value
from user_tab_partitions
where table_name = 'T_PAR'
order by partition_position desc;
pause
clear screen
create unique index T_PAR_PK 
  on T_PAR (pk) parallel 8;
alter index T_PAR_PK noparallel;  
alter table T_PAR
  add constraint T_PAR_PK
  primary key ( pk )
  using index;
pause
--
-- FYI
--
-- alter table T_PAR
--   add constraint T_PAR_PK
--   primary key ( pk )
--   using index ( create unique index T_PAR_PK
--            on T_PAR (pk) parallel 8 );
-- 
pause           
select partitioned
from user_indexes
where index_name = 'T_PAR_PK';
pause
clear screen
set timing on
alter table T_PAR drop partition p1;
set timing off
pause
select status
from user_indexes
where index_name = 'T_PAR_PK';
pause
insert into T_PAR (pk, par_date) 
values (0,sysdate);
pause
alter index T_PAR_PK rebuild parallel 8;
alter index T_PAR_PK noparallel;
pause
clear screen
select bytes/1024/1024 mb
from dba_segments
where segment_name = 'T_PAR_PK';
pause
set timing on
alter table T_PAR drop partition p2 update indexes;
set timing off
pause
select bytes/1024/1024 mb
from dba_segments
where segment_name = 'T_PAR_PK';
pause
select status
from user_indexes
where index_name = 'T_PAR_PK';
pause
insert into T_PAR (pk, par_date) 
values (0,sysdate);
pause
roll;
set echo off
set feedback off
clear screen
alter session set "_fast_index_maintenance" = true;
set feedback on
set echo on
--
-- 12c onwards
--
pause
set timing on
alter table T_PAR drop partition p3 update indexes;
set timing off
pause
insert into T_PAR (pk, par_date) 
values (0,sysdate);
pause
roll;
clear screen
select orphaned_entries
from user_indexes
where index_name = 'T_PAR_PK';
pause
set autotrace traceonly explain
select *
from t_par
where pk = :key;
pause
clear screen
select min(pk) 
from T_PAR;
set autotrace off
pause
clear screen
conn SYS_USER/PASSWORD@MY_PDB as sysdba
execute dbms_scheduler.run_job('SYS.PMO_DEFERRED_GIDX_MAINT_JOB',true)
pause
set echo off
clear screen
conn USER/PASSWORD@MY_PDB
set echo on
select orphaned_entries
from user_indexes
where index_name = 'T_PAR_PK';
pause
set autotrace traceonly explain
select min(pk) 
from T_PAR;
set autotrace off
pause
clear screen
select bytes/1024/1024 mb
from dba_segments
where segment_name = 'T_PAR_PK';
pause
alter index T_PAR_PK rebuild parallel 8;
alter index T_PAR_PK noparallel;  
pause
select bytes/1024/1024 mb
from dba_segments
where segment_name = 'T_PAR_PK';
pause
clear screen
alter table T_PAR
  drop constraint T_PAR_PK drop index;
pause
alter table T_PAR 
  add constraint T_PAR_PK 
  primary key ( pk )
  using index LOCAL
  
pause
/
pause
create unique index T_PAR_PK 
  on T_PAR (pk, par_date) parallel 8 local;
alter index T_PAR_PK noparallel;  
pause
alter table T_PAR
  add constraint T_PAR_PK
  primary key ( pk, par_date )
  using index LOCAL;
pause
clear screen
alter table T_PAR drop partition p4;
pause
select partition_name, status
from user_ind_partitions
where index_name = 'T_PAR_PK';
pause
clear screen
set autotrace traceonly explain
select *
from T_PAR
where pk = :key;
set autotrace off
pause
clear screen
set autotrace traceonly explain
select *
from T_PAR
where pk = :key
and par_date = :pardate;
set autotrace off
pause
clear screen
create table t_lookup
(pk,par_date,primary key (pk,par_date))
organization index as
select pk,par_date
from T_PAR;
exec dbms_stats.gather_table_stats('','T_LOOKUP');
pause
clear screen
set autotrace traceonly explain
select t.*
from T_PAR t,
     t_lookup
where t_lookup.pk = :key
and t.pk = t_lookup.pk
and t.par_date = t_lookup.par_date;
set autotrace off
pause
clear screen
alter table T_PAR drop partition p5;
pause
select partition_name, status
from user_ind_partitions
where index_name = 'T_PAR_PK';
pause
set autotrace traceonly explain
select t.*
from T_PAR t,
     t_lookup
where t_lookup.pk = :key
and t.pk = t_lookup.pk
and t.par_date = t_lookup.par_date;
set autotrace off
pause
clear screen
create or replace
view new_t as
select t.*
from T_PAR t,
     t_lookup
where t.pk = t_lookup.pk
and t.par_date = t_lookup.par_date;
pause
set autotrace traceonly explain
select *
from new_t
where pk = :key;
set autotrace off

