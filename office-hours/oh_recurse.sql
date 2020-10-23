REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
conn USER/PASSWORD@MY_DB
set verify off
col name format a30
set termout off
col value new_value old_value
set echo on
clear screen
@drop t
set termout on
@clean
set verify off
set echo on
create table T ( x int primary key, y int);
pause
insert into t
select rownum, rownum
from dual
connect by level <= 5000;
commit;
pause
clear screen


variable b1 number
exec :b1 := 1;
pause
clear screen
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause
select * from t where x = :b1;
pause
select s.name, st.value, &&old_value previous_value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause
select * from t where x = :b1;
pause
select s.name, st.value, &&old_value previous_value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause
--
-- and now we will do 100
--
pause
set feedback only



exec :b1 := 2;
select * from t where x = :b1;

exec :b1 := 3;
select * from t where x = :b1;

exec :b1 := 4;
select * from t where x = :b1;

exec :b1 := 5;
select * from t where x = :b1;

exec :b1 := 6;
select * from t where x = :b1;

exec :b1 := 7;
select * from t where x = :b1;

exec :b1 := 8;
select * from t where x = :b1;

exec :b1 := 9;
select * from t where x = :b1;

exec :b1 := 10;
select * from t where x = :b1;

exec :b1 := 11;
select * from t where x = :b1;

exec :b1 := 12;
select * from t where x = :b1;

exec :b1 := 13;
select * from t where x = :b1;

exec :b1 := 14;
select * from t where x = :b1;

exec :b1 := 15;
select * from t where x = :b1;

exec :b1 := 16;
select * from t where x = :b1;

exec :b1 := 17;
select * from t where x = :b1;

exec :b1 := 18;
select * from t where x = :b1;

exec :b1 := 19;
select * from t where x = :b1;

exec :b1 := 20;
select * from t where x = :b1;

exec :b1 := 21;
select * from t where x = :b1;

exec :b1 := 22;
select * from t where x = :b1;

exec :b1 := 23;
select * from t where x = :b1;

exec :b1 := 24;
select * from t where x = :b1;

exec :b1 := 25;
select * from t where x = :b1;

exec :b1 := 26;
select * from t where x = :b1;

exec :b1 := 27;
select * from t where x = :b1;

exec :b1 := 28;
select * from t where x = :b1;

exec :b1 := 29;
select * from t where x = :b1;

exec :b1 := 30;
select * from t where x = :b1;

exec :b1 := 31;
select * from t where x = :b1;

exec :b1 := 32;
select * from t where x = :b1;

exec :b1 := 33;
select * from t where x = :b1;

exec :b1 := 34;
select * from t where x = :b1;

exec :b1 := 35;
select * from t where x = :b1;

exec :b1 := 36;
select * from t where x = :b1;

exec :b1 := 37;
select * from t where x = :b1;

exec :b1 := 38;
select * from t where x = :b1;

exec :b1 := 39;
select * from t where x = :b1;

exec :b1 := 40;
select * from t where x = :b1;

exec :b1 := 41;
select * from t where x = :b1;

exec :b1 := 42;
select * from t where x = :b1;

exec :b1 := 43;
select * from t where x = :b1;

exec :b1 := 44;
select * from t where x = :b1;

exec :b1 := 45;
select * from t where x = :b1;

exec :b1 := 46;
select * from t where x = :b1;

exec :b1 := 47;
select * from t where x = :b1;

exec :b1 := 48;
select * from t where x = :b1;

exec :b1 := 49;
select * from t where x = :b1;

exec :b1 := 50;
select * from t where x = :b1;

exec :b1 := 51;
select * from t where x = :b1;

exec :b1 := 52;
select * from t where x = :b1;

exec :b1 := 53;
select * from t where x = :b1;

exec :b1 := 54;
select * from t where x = :b1;

exec :b1 := 55;
select * from t where x = :b1;

exec :b1 := 56;
select * from t where x = :b1;

exec :b1 := 57;
select * from t where x = :b1;

exec :b1 := 58;
select * from t where x = :b1;

exec :b1 := 59;
select * from t where x = :b1;

exec :b1 := 60;
select * from t where x = :b1;

exec :b1 := 61;
select * from t where x = :b1;

exec :b1 := 62;
select * from t where x = :b1;

exec :b1 := 63;
select * from t where x = :b1;

exec :b1 := 64;
select * from t where x = :b1;

exec :b1 := 65;
select * from t where x = :b1;

exec :b1 := 66;
select * from t where x = :b1;

exec :b1 := 67;
select * from t where x = :b1;

exec :b1 := 68;
select * from t where x = :b1;

exec :b1 := 69;
select * from t where x = :b1;

exec :b1 := 70;
select * from t where x = :b1;

exec :b1 := 71;
select * from t where x = :b1;

exec :b1 := 72;
select * from t where x = :b1;

exec :b1 := 73;
select * from t where x = :b1;

exec :b1 := 74;
select * from t where x = :b1;

exec :b1 := 75;
select * from t where x = :b1;

exec :b1 := 76;
select * from t where x = :b1;

exec :b1 := 77;
select * from t where x = :b1;

exec :b1 := 78;
select * from t where x = :b1;

exec :b1 := 79;
select * from t where x = :b1;

exec :b1 := 80;
select * from t where x = :b1;

exec :b1 := 81;
select * from t where x = :b1;

exec :b1 := 82;
select * from t where x = :b1;

exec :b1 := 83;
select * from t where x = :b1;

exec :b1 := 84;
select * from t where x = :b1;

exec :b1 := 85;
select * from t where x = :b1;

exec :b1 := 86;
select * from t where x = :b1;

exec :b1 := 87;
select * from t where x = :b1;

exec :b1 := 88;
select * from t where x = :b1;

exec :b1 := 89;
select * from t where x = :b1;

exec :b1 := 90;
select * from t where x = :b1;

exec :b1 := 91;
select * from t where x = :b1;

exec :b1 := 92;
select * from t where x = :b1;

exec :b1 := 93;
select * from t where x = :b1;

exec :b1 := 94;
select * from t where x = :b1;

exec :b1 := 95;
select * from t where x = :b1;

exec :b1 := 96;
select * from t where x = :b1;

exec :b1 := 97;
select * from t where x = :b1;

exec :b1 := 98;
select * from t where x = :b1;

exec :b1 := 99;
select * from t where x = :b1;

exec :b1 := 100;
select * from t where x = :b1;

set feedback on
select s.name, st.value, &&old_value previous_value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause
set termout off
clear screen
create index ix1 on t ( x+1);
create index ix2 on t ( x+2);
create index ix3 on t ( x+1,y);
create index ix4 on t ( x+1,y+1);

set termout on
alter system flush shared_pool;
pause

set feedback on
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';

pause

set feedback only
select * from t where x = 1;
select * from t where x = 2;
select * from t where x = 3;
select * from t where x = 4;
select * from t where x = 5;
select * from t where x = 6;
select * from t where x = 7;
select * from t where x = 8;
select * from t where x = 9;
select * from t where x = 10;
select * from t where x = 11;
select * from t where x = 12;
select * from t where x = 13;
select * from t where x = 14;
select * from t where x = 15;
select * from t where x = 16;
select * from t where x = 17;
select * from t where x = 18;
select * from t where x = 19;
select * from t where x = 20;
select * from t where x = 21;
select * from t where x = 22;
select * from t where x = 23;
select * from t where x = 24;
select * from t where x = 25;
select * from t where x = 26;
select * from t where x = 27;
select * from t where x = 28;
select * from t where x = 29;
select * from t where x = 30;
select * from t where x = 31;
select * from t where x = 32;
select * from t where x = 33;
select * from t where x = 34;
select * from t where x = 35;
select * from t where x = 36;
select * from t where x = 37;
select * from t where x = 38;
select * from t where x = 39;
select * from t where x = 40;
select * from t where x = 41;
select * from t where x = 42;
select * from t where x = 43;
select * from t where x = 44;
select * from t where x = 45;
select * from t where x = 46;
select * from t where x = 47;
select * from t where x = 48;
select * from t where x = 49;
select * from t where x = 50;
select * from t where x = 51;
select * from t where x = 52;
select * from t where x = 53;
select * from t where x = 54;
select * from t where x = 55;
select * from t where x = 56;
select * from t where x = 57;
select * from t where x = 58;
select * from t where x = 59;
select * from t where x = 60;
select * from t where x = 61;
select * from t where x = 62;
select * from t where x = 63;
select * from t where x = 64;
select * from t where x = 65;
select * from t where x = 66;
select * from t where x = 67;
select * from t where x = 68;
select * from t where x = 69;
select * from t where x = 70;
select * from t where x = 71;
select * from t where x = 72;
select * from t where x = 73;
select * from t where x = 74;
select * from t where x = 75;
select * from t where x = 76;
select * from t where x = 77;
select * from t where x = 78;
select * from t where x = 79;
select * from t where x = 80;
select * from t where x = 81;
select * from t where x = 82;
select * from t where x = 83;
select * from t where x = 84;
select * from t where x = 85;
select * from t where x = 86;
select * from t where x = 87;
select * from t where x = 88;
select * from t where x = 89;
select * from t where x = 90;
select * from t where x = 91;
select * from t where x = 92;
select * from t where x = 93;
select * from t where x = 94;
select * from t where x = 95;
select * from t where x = 96;
select * from t where x = 97;
select * from t where x = 98;
select * from t where x = 99;
select * from t where x = 100;
pause

set feedback on
select s.name, st.value, &&old_value previous_value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause

set termout off
conn USER/PASSWORD@MY_DB
set termout off
set verify off
set echo on

clear screen
declare
   v int;
begin
  for i in 1 .. 100 loop
    select y into v from t where x = i;
  end loop;
end;
/
set termout on

select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause

declare
   v int;
begin
  for i in 1 .. 100 loop
    select y into v from t where x = i;
  end loop;
end;
/
pause


select s.name, st.value, &&old_value previous_value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause

clear screen
create or replace
function get_stuff( p int) return number is
  res int;
begin
  select y into res from t where x = p;
  return res;
end;
/
pause
clear screen
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause

set feedback only
select x, get_stuff(x)
from t;

set feedback on
select s.name, st.value, &&old_value previous_value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause

clear screen
create or replace
function get_stuff( p int) return number is
  res int;
begin
  execute immediate 
    'select y from t where x = '||p into res ;
  return res;
end;
/

pause
clear screen
select s.name, st.value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
pause

set feedback only
select x, get_stuff(x)
from t;

set feedback on
select s.name, st.value, &&old_value previous_value
from v$statname s, v$mystat st
where st.statistic# = s.statistic#
and s.name = 'recursive calls';
