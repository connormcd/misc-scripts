REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

@drop one_pass
set echo on
clear screen
create table ONE_PASS 
as select substr(text,1,1) single_char
from DBA_SOURCE;
pause
select count(distinct single_char) ndv 
from one_pass;
pause
set termout off
clear screen
delete from one_pass where single_char = '}';
set echo on
set termout on
set serverout on
declare
  type t_bucket is table of varchar2(1)
    index by pls_integer;
  l_synopsis          t_bucket;
  l_splits            number := 0;
  l_hash              int;
  l_min_val           int := 0;
  l_synopsis_size     int := 16;
begin
  for i in ( select single_char from one_pass ) loop
    l_hash := ascii(i.single_char);
#pause
    if l_synopsis.count = l_synopsis_size then
       l_min_val :=
         case
           when l_min_val = 0 then 64
           when l_min_val = 64 then 96
           when l_min_val = 96 then 112
           when l_min_val = 112 then 120
         end;
       dbms_output.put_line(l_min_val);
       l_splits := l_splits + 1;
#pause
       for j in 1 .. l_min_val loop
          if l_synopsis.exists(j) then
              l_synopsis.delete(j);
          end if;
       end loop;
    end if;

    if l_hash > l_min_val then
      l_synopsis(l_hash) := 'Y';
    end if;
  end loop;
  dbms_output.put_line('NDV='||l_synopsis.count * power(2,l_splits));
end;
.
pause
/

