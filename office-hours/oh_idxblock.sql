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
@drop tab4k
@drop tab8k
clear screen
set termout on
set echo on
conn SYS_USER/PASSWORD as sysdba
set echo on
alter system set db_4k_cache_size = 100m;
pause
set termout off
clear screen
conn USER/PASSWORD@MY_PDB
set echo on
--create tablespace ts4k 
--datafile 'X:\ORADATA\DB21\PDB21A\TS4K.DBF' size 1g 
--blocksize 4k;
pause
create table tab4k 
(x int, constraint tab4k_pk primary key(x))
organization index
tablespace ts4k;
pause
insert into tab4k values (0);
commit;
analyze index tab4k_pk validate structure;
pause
select height, distinct_keys from index_stats;
pause
clear screen
insert into tab4k
select rownum
from dual
connect by level <= 500;
commit;
pause
analyze index tab4k_pk validate structure;
select height, distinct_keys from index_stats;
pause
insert into tab4k values (501);
commit;
pause
analyze index tab4k_pk validate structure;
select height, distinct_keys from index_stats;
pause
clear screen
insert into tab4k
select 501+rownum
from dual
connect by level <= 157290;
commit;
pause
analyze index tab4k_pk validate structure;
select height, distinct_keys from index_stats;
pause
insert into tab4k values (157793);
commit;
analyze index tab4k_pk validate structure;
select height, distinct_keys from index_stats;
pause
clear screen
-- SQL> set serverout on
-- SQL> declare
--   2    h int;
--   3    d int := 157793;
--   4  begin
--   5    loop
--   6      insert into tab4k
--   7      select d+rownum
--   8      from dual
--   9      connect by level <= 1000000;
--  10      commit;
--  11      execute immediate
--  12        'analyze index tab4k_pk validate structure';
--  13      select height, distinct_keys
--  14      into h,d
--  15      from index_stats;
--  16
--  17      if h > 3 then
--  18        dbms_output.put_line('Keys='||d);
--  19        exit;
--  20      end if;
--  21    end loop;
--  22  end;
--  23  /
-- 
-- Keys=42,657,793
-- 
-- PL/SQL procedure successfully completed.
-- 
pause
clear screen
create table tab8k
(x int, constraint tab8k_pk primary key(x))
organization index;
pause
insert into tab8k values (0);
commit;
analyze index tab8k_pk validate structure;
select height, distinct_keys from index_stats;
pause
clear screen
insert into tab8k
select rownum
from dual
connect by level <= 1012;
commit;
analyze index tab8k_pk validate structure;
select height, distinct_keys from index_stats;
pause
insert into tab8k values (1013);
commit;
analyze index tab8k_pk validate structure;
select height, distinct_keys from index_stats;
pause
clear screen
insert into tab8k
select 1013+rownum
from dual
connect by level <= 650919;
commit;
analyze index tab8k_pk validate structure;
select height, distinct_keys from index_stats;
pause
insert into tab8k values (651934);
commit;
analyze index tab8k_pk validate structure;
select height, distinct_keys from index_stats;
pause
clear screen
-- SQL>     insert /*+ APPEND */ into tab8k
--   2      select rownum
--   3      from
--   4      ( select 1 from dual connect by level <= 10000),
--   5      ( select 1 from dual connect by level <= 15000);
-- 
-- 150000000 rows created.
-- 
pause
-- 
-- SQL> set serverout on
-- SQL> set timing on
-- SQL> declare
--   2    h int;
--   3    d int := 150000000;
--   4  begin
--   5    loop
--   6      insert /*+ APPEND */ into tab8k
--   7      select d+rownum
--   8      from
--   9      ( select 1 from dual connect by level <= 2000),
--  10      ( select 1 from dual connect by level <= 1000);
--  11      d := d + sql%rowcount;
--  12      commit;
--  13      dbms_stats.gather_index_stats('','TAB8K_PK');
--  14      select blevel
--  15      into h
--  16      from user_indexes
--  17      where index_name = 'TAB8K_PK';
--  18      if h > 2 then
--  19        dbms_output.put_line('Keys='||d);
--  20        exit;
--  21      end if;
--  22    end loop;
--  23  end;
--  24  /
-- Keys=200,000,000
-- 