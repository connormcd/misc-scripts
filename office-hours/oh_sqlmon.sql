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
col predicates format a60 wrap
set lines 180
set echo on
clear screen
set termout on

--drop table t purge;
--create table t ( x xmltype);

--insert into t
--select DBMS_SQLTUNE.REPORT_SQL_MONITOR_XML(
--  sql_id=>'6ujwzgphq1zht',
--  report_level=>'ALL')
--from dual;
--
--commit;
pause
clear screen

--with t as 
--(
--select DBMS_SQLTUNE.REPORT_SQL_MONITOR_XML(
--  sql_id=>'8bx0tnbb2gd4m',
--  report_level=>'ALL') x
--from dual
--)
SELECT rp.name, rp.id, pr.*
FROM   t,
       XMLTABLE('/report/sql_monitor_report/plan/operation'
         PASSING t.x
         COLUMNS 
           name               VARCHAR2(30)  PATH '@name',
           id                 VARCHAR2(30)  PATH '@id',
           pred               XMLTYPE  PATH 'predicates'
         ) rp
      left outer join
         XMLTABLE('/'
           passing rp.pred
           COLUMNS 
           predicates               VARCHAR2(4000)  PATH '.'
         ) pr on 1=1

pause
/


