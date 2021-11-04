drop table F1_CIRCUITS purge;
drop table F1_CONSTRUCTORRESULTS purge;
drop table F1_CONSTRUCTORS purge;
drop table F1_CONSTRUCTORSTANDINGS purge;
drop table F1_DRIVERS purge;
drop table F1_DRIVERSTANDINGS purge;
drop table F1_LAPTIMES purge;
drop table F1_PITSTOPS purge;
drop table F1_QUALIFYING purge;
drop table F1_RACES purge;
drop table F1_RESULTS purge;
drop table F1_SEASONS purge;
drop table F1_STATUS purge;

alter session set cursor_sharing = force;
alter session set nls_date_format = 'yyyy-mm-dd';
set feedback off
set define off
@f1_build.sql
commit;
alter session set cursor_sharing = exact;
set feedback on
set define '&'
alter session set nls_date_format = 'DD-MON-YY';

exec dbms_stats.gather_table_stats('','F1_CIRCUITS');
exec dbms_stats.gather_table_stats('','F1_CONSTRUCTORRESULTS');
exec dbms_stats.gather_table_stats('','F1_CONSTRUCTORS');
exec dbms_stats.gather_table_stats('','F1_CONSTRUCTORSTANDINGS');
exec dbms_stats.gather_table_stats('','F1_DRIVERS');
exec dbms_stats.gather_table_stats('','F1_DRIVERSTANDINGS');
exec dbms_stats.gather_table_stats('','F1_LAPTIMES');
exec dbms_stats.gather_table_stats('','F1_PITSTOPS');
exec dbms_stats.gather_table_stats('','F1_QUALIFYING');
exec dbms_stats.gather_table_stats('','F1_RACES');
exec dbms_stats.gather_table_stats('','F1_RESULTS');
exec dbms_stats.gather_table_stats('','F1_SEASONS');
exec dbms_stats.gather_table_stats('','F1_STATUS');
