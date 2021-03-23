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
conn USERNAME/PASSWORD@DATABASE_SERVICE 
set termout off
exec dbms_sql_translator.drop_profile('DEMO_PROFILE');
exec dbms_sql_translator.drop_profile('SILLY');
alter system flush shared_pool;
grant translate sql on user scott to USERNAME;

set termout on
set echo on
clear screen

exec dbms_sql_translator.create_profile('SILLY');
pause
begin
  dbms_sql_translator.register_sql_translation(
     'SILLY',
     'select * from scott.emp',
     'select * from scott.dept');
end;
/
pause
clear screen
grant all on sql translation profile silly to scott;
pause
alter session set sql_translation_profile = SILLY;
pause
select * from scott.emp;
pause
clear screen
alter session set events = '10601 trace name context forever, level 32';
pause
select * from scott.emp;
pause
alter session set sql_translation_profile = null;
pause

set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
clear screen
exec dbms_sql_translator.drop_profile('SILLY');
pause

begin
  dbms_sql_translator.create_profile(
     profile_name => 'DEMO_PROFILE');
   
 dbms_sql_translator.set_attribute(
    profile_name   => 'DEMO_PROFILE',
    attribute_name => dbms_sql_translator.ATTR_FOREIGN_SQL_SYNTAX,
    attribute_value=> dbms_sql_translator.ATTR_VALUE_FALSE);

  dbms_sql_translator.register_sql_translation(
     profile_name   => 'DEMO_PROFILE',
     sql_text       =>'select * from scott.emp',
     translated_text=>'select * from scott.dept');

end;
/
pause
clear screen
grant all on sql translation profile DEMO_PROFILE to scott;
pause
alter session set sql_translation_profile = DEMO_PROFILE;
pause
select * from scott.emp;
pause

set termout off
conn USERNAME/PASSWORD@DATABASE_SERVICE
clear screen

exec dbms_sql_translator.drop_profile('DEMO_PROFILE');
pause

create or replace
package date_translator is
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
package body date_translator is
  procedure translate_sql(
               sql_text in clob, 
               translated_text out clob ) is
  begin
    translated_text := 
         regexp_replace(sql_text, 'SYSDATE', 'CURRENT_DATE-50*365', 1, 0, 'i');
    translated_text := 
         regexp_replace(translated_text, 'SYSTIMESTAMP', 'CURRENT_TIMESTAMP', 1, 0, 'i');
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
     attribute_value=> 'USERNAME.DATE_TRANSLATOR');

end;
/
grant all on sql translation profile DEMO_PROFILE to scott;
pause
clear screen

select * from scott.emp;
pause
select * from scott.emp where hiredate < sysdate;
pause
clear screen
alter session set sql_translation_profile = DEMO_PROFILE;
pause
select * from scott.emp;
pause
select * from scott.emp where hiredate < sysdate;
pause
clear screen
select sql_text from v$sql
where sql_text like 'selec%emp%hiredate%';
pause

alter session set sql_translation_profile = null;
exec dbms_sql_translator.drop_profile('DEMO_PROFILE');
