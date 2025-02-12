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
create or replace 
type numlist is table of number
/
clear screen
set timing off
@drop t
create table t ( x int primary key );
set time off
set pages 999
set termout on
clear screen
set echo on
create private temporary table ora$ptt_ids
  ( id int )
on commit preserve definition;  
pause
begin
 for i in 1 .. 10000
 loop
   insert into ora$ptt_ids
   values (i);
 end loop;
end; 
/
pause
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
  l_ts := localtimestamp;
  execute immediate 
    'select count(*) from t where x in '||
    '( select id from ora$ptt_ids )' into l_res;
  dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
/
pause
clear screen
truncate table ora$ptt_ids;
pause
begin
 for i in 1 .. 100000
 loop
   insert into ora$ptt_ids
   values (i);
 end loop;
end; 
/
pause
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
  l_ts := localtimestamp;
  execute immediate 
    'select count(*) from t where x in '||
    '( select id from ora$ptt_ids )' into l_res;
  dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
/
pause
clear screen
declare
  idlist numlist := numlist(); 
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
  idlist.extend(100000);
 for i in 1 .. 100000
 loop
   idlist(i) := i;
 end loop;

#pause

  l_ts := localtimestamp;
  select count(*) 
  into   l_res
  from t where x in 
    ( select column_value
      from table(idlist));
  dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
/
