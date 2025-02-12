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
col c1 format clear
col c2 format clear
col c3 format clear
set numformat ""
conn USER/PASSWORD@MY_PDB
set termout off
@drop t
col d format a30
set termout off
clear screen
set timing off
set feedback on
set echo on
clear screen
set termout on

create table t
( c1 number,
  c2 number(38),
  c3 number(10),
  c4 float,
  c5 numeric(10,2),
  c6 decimal,
  c7 int,
  c8 smallint
);
pause
insert into t 
values (177,177,177,177,177,177,177,177);
commit;
pause
clear screen
select dump(c1) d, vsize(c1) v from t;
select dump(c2) d, vsize(c2) v from t;
select dump(c3) d, vsize(c3) v from t;
select dump(c4) d, vsize(c4) v from t;
pause
select dump(c5) d, vsize(c5) v from t;
select dump(c6) d, vsize(c6) v from t;
select dump(c7) d, vsize(c7) v from t;
select dump(c8) d, vsize(c8) v from t;
pause
set lines 60
clear screen
desc t
pause
set lines 120
clear screen
delete t;
insert into t 
values (1/7, 1/7,1/7,1/7,1/7,1/7,1/7,1/7);
pause
clear screen
select c1 ,c2 ,c3,c4 from t;
select c5,c6,c7,c8 from t;
pause
clear screen
select c1, dump(c1) d, vsize(c1) v from t;
pause
select c2, dump(c2) d, vsize(c2) v from t;
pause
select c4, dump(c4) d, vsize(c4) v from t;
pause
select c5, dump(c5) d, vsize(c5) v from t;
pause
clear screen
drop table t purge;
create table t (c1 number(5,2), c2 float, c3 float(5));
pause
insert into t values (1.23, 1.23, 1.23);
pause
select * from t;
pause
clear screen
drop table t purge;
create table t ( c1 number, c2 binary_float, c3 binary_double );
pause
insert into t values (100.04,100.04,100.04);
pause
col c1 format 99999999.9999999999
col c2 format 99999999.9999999999
col c3 format 99999999.9999999999
select * from t;
pause
col c3 format 99999999.999999999999999999999
select * from t;
