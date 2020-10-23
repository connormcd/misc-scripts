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
@drop string_date
@drop number_date
@drop real_date
alter session set nls_date_format = 'dd-MON-yyyy';
set echo on
clear screen
set termout on

create table STRING_DATE  as
  select 
     to_char( 
       to_date('01-jan-1995','dd-mon-yyyy')+rownum, 'yyyymmdd' ) x
  from all_objects;
pause

create table NUMBER_DATE  as
  select 
    to_number(
      to_char( 
        to_date('01-jan-1995','dd-mon-yyyy')+rownum, 'yyyymmdd' )) x
  from all_objects;
pause

create table REAL_DATE  as
  select to_date('01-jan-1995','dd-mon-yyyy')+rownum x
  from all_objects;
pause

clear screen
create index str_IX on STRING_DATE(x);
create index num_IX on NUMBER_DATE(x);
create index real_IX on REAL_DATE(x);
pause
clear screen
select min(x), max(x) from STRING_DATE;
select min(x), max(x) from NUMBER_DATE;
select min(x), max(x) from REAL_DATE;
pause
clear screen
set autotrace traceonly explain

select * from STRING_DATE
where x between '20050107' and '20050114';
pause
clear screen

select * from NUMBER_DATE
where x between 20050107 and 20050114;
pause
clear screen

select * from REAL_DATE
where x between to_date('20050107','yyyymmdd') 
          and to_date('20050114','yyyymmdd');
pause
clear screen

select * from STRING_DATE
where x between '20001231' and '20010101';
pause
clear screen

select * from NUMBER_DATE
where x between 20001231 and 20010101;
pause
clear screen

select * from REAL_DATE
where x between to_date('20001231','yyyymmdd') 
            and to_date('20010101','yyyymmdd');
pause
clear screen

begin dbms_stats.gather_table_stats('','STRING_DATE',
           method_opt=>'for all columns size auto');
end;
/

begin dbms_stats.gather_table_stats('','NUMBER_DATE',
           method_opt=>'for all columns size auto');
end;
/
pause
clear screen

select * from STRING_DATE
where x between '20001231' and '20010101';
pause
clear screen

select * from NUMBER_DATE
where x between 20001231 and 20010101;
