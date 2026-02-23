clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
set long 10000
@drop small_stuff
@drop large_stuff
@drop mydocs

clear screen
set termout on
set echo off
set serverout on
prompt |   
prompt |     _      ____  ____            __      __     _     _    _ ______ 
prompt |    | |    / __ \|  _ \           \ \    / /\   | |   | |  | |  ____|
prompt |    | |   | |  | | |_) |           \ \  / /  \  | |   | |  | | |__   
prompt |    | |   | |  | |  _ <             \ \/ / /\ \ | |   | |  | |  __|  
prompt |    | |___| |__| | |_) |             \  / ____ \| |___| |__| | |____ 
prompt |    |______\____/|____/               \/_/    \_\______\____/|______|
prompt |                          ______                                     
prompt |                         |______|                                    
prompt |   
prompt |   
pause
clear screen
set echo on
clear screen
--
-- In the good 'ol days..., ie, Oracle 8.0 :-)
--
pause
--
-- My structured data, typically small
--
create table small_stuff (id int, data VARCHAR2(4000));
pause
--
-- My unstructured (pdf,jpg,mp4,xlsx,docx), typically large
--
create table large_stuff (id int, data BLOB);
pause
--
-- LOB = LARGE object
--
pause
set echo off
clear screen
prompt +--------------------------------------------------------+
prompt |                                                        |
prompt |  Name           Job              Photo                 |
prompt |  ============== ===============  =================     |
prompt |  Connor         DB               <AAA>                 |
prompt |  Mike           APEX             <BBB>                 |
prompt |  Mary           Spatial          <CCC>                 |
prompt |  Hari           RAC              <DDD>                 |
prompt |  ...                                                   |
prompt |                                                        |
prompt +--------------------------------------------------------+
pause
set echo on
clear screen
insert into small_stuff
select rownum, rpad('f',4000,'f')
connect by level <= 1000;
pause
insert into large_stuff
select rownum, hextoraw(rpad('f',8000,'f'))
connect by level <= 1000;
commit;
pause
clear screen
set timing on
set autotrace traceonly stat
select * from small_stuff;
pause
clear screen
select * from large_stuff;
pause
set autotrace off
set timing off
clear screen
--
-- The world changed...
--
create table mydocs ( id int, MYJSON blob);
pause
insert into mydocs
select rownum, utl_raw.cast_to_raw('{ "sample" : "'||rpad(rownum,4000,'f')||'" }' )
connect by level <= 2000;
commit;
pause
set timing on
clear screen
set feedback only
select * from mydocs;
pause
clear screen
select id, lob_value(myjson) from mydocs
.
pause
/
pause
clear screen
alter table mydocs modify lob (myjson ) query as value ;
pause
select * from mydocs;

pause Done
set feedback on
