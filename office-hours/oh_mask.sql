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
conn USERNAME/PASSWORD@SERVICE_NAME 
set termout off
exec dbms_sql_translator.drop_profile('DEMO_PROFILE');
alter system flush shared_pool;
set serverout off
grant translate sql on user scott to USERNAME;
alter session set sql_translation_profile = null;
drop table scott.bigtab purge;
col padding nopri
set lines 200
clear screen
set termout on
set echo on
create table scott.bigtab as 
select e.*, 
       date '2020-01-01' + rownum/140 dte,
       rpad('x',1000) padding
from scott.emp e,
 ( select 1 from dual 
   connect by level <= 10005 )
where rownum <= 140003;
pause
select min(dte), max(dte)
from scott.bigtab;
pause
clear screen
set autotrace on stat
select *
from scott.bigtab
where dte >= to_date('2022-09-27','YYYY-MM-DD');
pause
clear screen
create index scott.bigtab_ix 
on scott.bigtab (dte );
pause
set autotrace on stat
select *
from scott.bigtab
where dte >= to_date('2022-09-27','YYYY-MM-DD');
pause
set autotrace off
select * from dbms_xplan.display_cursor();
pause
clear screen
set autotrace on stat
select *
from scott.bigtab
where to_char(dte,'YYYY-MM-DD') >= '2022-09-27';
pause
clear screen
create index scott.bigtab_ix_fbi
on scott.bigtab ( to_char(dte,'YYYY-MM-DD') );
pause
set autotrace on stat
clear screen
select *
from scott.bigtab
where to_char(dte,'YYYY-MM-DD') >= '2022-09-27';
pause
clear screen
set autotrace on stat
select *
from scott.bigtab
where to_char(dte,'yyyy-mm-dd') >= '2022-09-27';
pause
set autotrace off
select * from dbms_xplan.display_cursor();
pause
clear screen
create or replace
package mask_translate is
  procedure translate_sql(
                 sql_text in clob, 
                 translated_text out clob );
  procedure translate_error(
                 error_code in binary_integer, 
                 translated_code out binary_integer, 
                 translated_sqlstate out varchar2);
end;
/
pause
clear screen
create or replace
package body mask_translate is
  procedure translate_sql(
               sql_text in clob, 
               translated_text out clob ) is 
    masks sys.odcivarchar2list := 
      sys.odcivarchar2list('yy','mm','dd','hh','mi','ss','ff');
  begin
    translated_text := sql_text;
    for i in 1 .. masks.count loop
      translated_text := replace(translated_text,masks(i),upper(masks(i)));
    end loop;
  end;
  
  procedure translate_error(
                  error_code in binary_integer, 
                  translated_code out binary_integer, 
                  translated_sqlstate out varchar2) is
  begin
    null;
  end;
end;
/
pause
clear screen
begin
  dbms_sql_translator.create_profile(
     profile_name => 'DEMO_PROFILE');
   
 dbms_sql_translator.set_attribute(
    profile_name   => 'DEMO_PROFILE',
    attribute_name => dbms_sql_translator.ATTR_FOREIGN_SQL_SYNTAX,
    attribute_value=> dbms_sql_translator.ATTR_VALUE_FALSE);

  dbms_sql_translator.set_attribute(
     profile_name   => 'DEMO_PROFILE',
     attribute_name => dbms_sql_translator.attr_translator,
     attribute_value=> 'USERNAME.mask_translate');

end;
/
pause
grant all on sql translation profile DEMO_PROFILE to scott;
pause
alter session set sql_translation_profile = DEMO_PROFILE;
pause
clear screen
select * from scott.emp 
where to_char(hiredate,'yyyymmdd') < '20200101';
pause
select sql_text from v$sql
where sql_text like 'selec%emp%hiredate%';
pause
clear screen
set autotrace on stat
select *
from scott.bigtab
where to_char(dte,'YYYY-MM-DD') >= '2022-09-27';
pause
clear screen
set autotrace on stat
select *
from scott.bigtab
where to_char(dte,'yyyy-mm-dd') >= '2022-09-27';
pause
set autotrace off
select * from dbms_xplan.display_cursor();
pause
clear screen
rem
rem Why sys.odcivarchar2list('yy','mm','dd','hh','mi','ss','ff') ???
rem 
pause
alter session set sql_translation_profile = null;
pause
select *
from scott.bigtab
where to_char(dte,'YYYY/mon/DD') = '2022/sep/27';
pause
select *
from scott.bigtab
where to_char(dte,'YYYY/MON/DD') = '2022/sep/27';
pause

rem
rem cleanup
rem
alter session set sql_translation_profile = null;
exec dbms_sql_translator.drop_profile('DEMO_PROFILE');
drop table scott.bigtab purge;



