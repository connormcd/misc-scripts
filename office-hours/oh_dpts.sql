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
clear screen
drop user dp cascade;
col high_value format a20
set timing off
set time off
set pages 999
set lines 200
set termout on
clear screen
set feedback on
set echo on
grant dba to dp identified by dp;
pause
conn dp/dp@DB_SERVICE
pause
create table t partition by list ( x )
( 
  partition p_asktom  values (1) tablespace asktom,
  partition p_largets values (2) tablespace largets,
  partition p_soe     values (3) tablespace soe,
  partition p_users   values (4) tablespace users
) as
select 1 x, e.* from scott.emp e union all
select 2 x, e.* from scott.emp e union all
select 3 x, e.* from scott.emp e union all
select 4 x, e.* from scott.emp e;
pause
select segment_name, partition_name
from   dba_segments
where  tablespace_name = 'LARGETS';
pause
clear screen
host del c:\tmp\largets.dmp
host del c:\tmp\largets.log
pause
declare
  l_job     number;
  l_status  varchar2(200);
begin
  l_job := dbms_datapump.open(operation => 'EXPORT',
             job_mode  => 'TABLESPACE');
  
  dbms_datapump.add_file(
    handle    => l_job,
    filename  => 'largets.dmp',
    directory => 'CTMP',
    filetype    => dbms_datapump.ku$_file_type_dump_file,
    reusefile   => 1);
                         
  dbms_datapump.add_file(handle    => l_job,
                         filename  => 'largets.log',
                         directory => 'CTMP',
                         filetype  => dbms_datapump.ku$_file_type_log_file,
                         reusefile   => 1);
             
  dbms_datapump.metadata_filter(
     handle => l_job, 
     name   => 'SCHEMA_EXPR', VALUE => 'IN(''DP'')');
  dbms_datapump.metadata_filter (
     handle => l_job, 
     name   => 'TABLESPACE_EXPR', value => 'IN(''LARGETS'')');
     
  dbms_datapump.start_job(l_job);
  dbms_datapump.wait_for_job(l_job,l_status);

end;
.

pause
/
pause
host cat c:\tmp\largets.log
pause
host del c:\tmp\largets.dmp
host del c:\tmp\largets.log
clear screen
declare
  l_job number;
  l_status  varchar2(200);
begin
  l_job := dbms_datapump.open(operation => 'EXPORT',job_mode  => 'TABLESPACE');
  
  dbms_datapump.add_file(
    handle    => l_job,
    filename  => 'largets.dmp',
    directory => 'CTMP',
    filetype    => dbms_datapump.ku$_file_type_dump_file,
    reusefile   => 1);
                         
  dbms_datapump.add_file(
    handle    => l_job,
    filename  => 'largets.log',
    directory => 'CTMP',
    filetype  => dbms_datapump.ku$_file_type_log_file,
    reusefile   => 1);
             
  dbms_datapump.metadata_filter(
     handle => l_job, 
     name   => 'SCHEMA_EXPR', VALUE => 'IN(''DP'')');
  dbms_datapump.metadata_filter (
     handle => l_job, 
     name   => 'TABLESPACE_EXPR', value => 'IN(''LARGETS'')');
#pause     
  dbms_datapump.data_filter (
    handle      => l_job,
    name        => 'PARTITION_LIST',
    value       => '''P_LARGETS''',
    table_name  => 'T',
    schema_name => 'DP');

  dbms_datapump.start_job(l_job);
  dbms_datapump.wait_for_job(l_job,l_status);

end;
.

pause
/
pause
host cat c:\tmp\largets.log
