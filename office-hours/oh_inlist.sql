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
alter system flush shared_pool;
clear screen
set timing off
@drop t
@drop t1
set time off
set pages 999
set termout on
clear screen
set echo on
create table t ( x int primary key );
pause
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
    l_sql := 'select count(*) from t where x in (1';
    for i in 2 .. 10
    loop
      l_sql := l_sql || ','||i;
    end loop;
    l_sql := l_sql||')';  
    dbms_output.put_line(l_sql);
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
.
pause
/
pause
clear screen
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
    l_sql := 'select count(*) from t where x in (1';
    for i in 2 .. 1000   -- <<<=====
    loop
      l_sql := l_sql || ','||i;
    end loop;
    l_sql := l_sql||')'; 
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
.
pause
/
pause
clear screen
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
    l_sql := 'select count(*) from t where x in (1';
    for i in 2 .. 1001   -- <<<=====
    loop
      l_sql := l_sql || ','||i;
    end loop;
    l_sql := l_sql||')'; 
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
.
pause
/
pause


clear screen
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
    l_sql := 'select count(*) from t where x in (1';
    for i in 2 .. 1000
    loop
      l_sql := l_sql || ','||i;
    end loop;
    l_sql := l_sql||') or x in (1001'; 
    for i in 1002 .. 2000
    loop
      l_sql := l_sql || ','||i;
    end loop;
    l_sql := l_sql||')'; 
    
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
.
pause
/
pause

clear screen
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
    l_sql := 'select count(*) from t where (x,0) '||chr(10)||' in ( (1,0)';
    for i in 2 .. 10
    loop
      l_sql := l_sql || ',('||i||',0)';
    end loop;
    l_sql := l_sql||')'; 
    dbms_output.put_line(l_sql);
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
.
pause
/
pause

clear screen
set serverout on
declare
  l_sql clob;
  l_res int;
  l_ts timestamp;
begin
    l_sql := 'select count(*) from t where (x,0) in ( (1,0)';
    for i in 2 .. 2000
    loop
      l_sql := l_sql || ',('||i||',0)';
    end loop;
    l_sql := l_sql||')'; 
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line('Elapsed='||(localtimestamp-l_ts));
end;
.
pause
/
pause
clear screen

declare
  l_sql clob;
  l_chunk clob;
  l_res int;
  l_thousands sys.odcinumberlist :=
      sys.odcinumberlist(4,8,12,16);
      
  l_ts timestamp;
begin
  dbms_lob.createtemporary(l_sql,true);
  for sz in 1 .. l_thousands.count
  loop
    l_sql := 'select count(*) from t where (x,0) in ( (1,0)';
    for thou in 0 .. l_thousands(sz)-1
    loop
      l_chunk := null;
      for i in 1 .. 1000
      loop
         l_chunk := l_chunk || ',('||(thou*1000+i)||',0)';
      end loop;
      dbms_lob.writeappend(l_sql, length(l_chunk), l_chunk);
    end loop;
    dbms_lob.writeappend(l_sql, 1,')');
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line(l_thousands(sz) ||'k :'||(localtimestamp-l_ts));
  end loop;
end;
.
pause
/
pause
clear screen
--
-- Why parsing cost?
--
pause
create table t1 ( x int, y int , z char(20));
pause
insert into t1 
select rownum, rownum, 'x' 
from dual
connect by level <= 100000;
pause
insert into t1 
select rownum, 0, 'x'
from dual
connect by level <= 100000;
pause
exec dbms_stats.gather_table_stats('','T1',method_opt=>'for all columns size 254');
pause
create index ix on t1 ( y ) ;
pause
set autotrace traceonly explain
select *
from t1
where y in (1,2,3,4,5,6,7,8,9,10)

pause
/
pause
select *
from t1
where y in (0,1,2,3,4,5,6,7,8,9,10)

pause
/
set autotrace off
pause
clear screen
--| declare
--|   l_sql clob;
--|   l_chunk clob;
--|   l_res int;
--|   l_thousands sys.odcinumberlist :=
--|       sys.odcinumberlist(65,66);
--|       
--|   l_ts timestamp;
--| begin
--|   dbms_lob.createtemporary(l_sql,true);
--|   for sz in 1 .. l_thousands.count
--|   loop
--|     l_sql := 'select count(*) from t where (x,0) in ( (1,0)';
--|     for thou in 0 .. l_thousands(sz)-1
--|     loop
--|       l_chunk := null;
--|       for i in 1 .. 1000
--|       loop
--|          l_chunk := l_chunk || ',('||(thou*1000+i)||',0)';
--|       end loop;
--|       dbms_lob.writeappend(l_sql, length(l_chunk), l_chunk);
--|     end loop;
--|     dbms_lob.writeappend(l_sql, 1,')');
--|     l_ts := localtimestamp;
--|     execute immediate l_sql into l_res;
--|     dbms_output.put_line(l_thousands(sz) ||'k :'||(localtimestamp-l_ts));
--|   end loop;
--| end;

pause

--| SQL> declare
--|   2    l_sql clob;
--|   3    l_chunk clob;
--|   4    l_res int;
--|   5    l_thousands sys.odcinumberlist :=
--|   6        sys.odcinumberlist(65,66);
--|   7
--|   8    l_ts timestamp;
--|   9  begin
--|  10    dbms_lob.createtemporary(l_sql,true);
--|  11    for sz in 1 .. l_thousands.count
--|  12    loop
--|  13      l_sql := 'select count(*) from t where (x,0) in ( (1,0)';
--|  14      for thou in 0 .. l_thousands(sz)-1
--|  15      loop
--|  16        l_chunk := null;
--|  17        for i in 1 .. 1000
--|  18        loop
--|  19           l_chunk := l_chunk || ',('||(thou*1000+i)||',0)';
--|  20        end loop;
--|  21        dbms_lob.writeappend(l_sql, length(l_chunk), l_chunk);
--|  22      end loop;
--|  23      dbms_lob.writeappend(l_sql, 1,')');
--|  24      l_ts := localtimestamp;
--|  25      execute immediate l_sql into l_res;
--|  26      dbms_output.put_line(l_thousands(sz) ||'k :'||(localtimestamp-l_ts));
--|  27    end loop;
--|  28  end;
--|  
--| 65k :+000000000 00:02:59.910000000
--| declare
--| *
--| ERROR at line 1:
--| ORA-00913: too many values
--| ORA-06512: at line 25

pause

clear screen
declare
  l_sql clob;
  l_chunk clob;
  l_res int;
  l_thousands sys.odcinumberlist :=
      sys.odcinumberlist(2,4);
      
  l_ts timestamp;
begin
  dbms_lob.createtemporary(l_sql,true);
  for sz in 1 .. l_thousands.count
  loop
    l_sql := 'select count(*) from t where x in (1';
    for thou in 0 .. l_thousands(sz)-1
    loop
      l_chunk := null;
      for i in 2 .. 1000
      loop
         l_chunk := l_chunk || ','||(thou*1000+i);
      end loop;
      l_chunk := l_chunk || ') or x in (0';
      dbms_lob.writeappend(l_sql, length(l_chunk), l_chunk);
    end loop;
    dbms_lob.writeappend(l_sql, 1,')');
    l_ts := localtimestamp;
    execute immediate l_sql into l_res;
    dbms_output.put_line(l_thousands(sz) ||'k :'||(localtimestamp-l_ts));
  end loop;
end;
.
pause
/
pause

clear screen
--| declare
--|   l_sql clob;
--|   l_chunk clob;
--|   l_res int;
--|   l_thousands sys.odcinumberlist :=
--|       sys.odcinumberlist(65,66);
--|       
--|   l_ts timestamp;
--| begin
--|   dbms_lob.createtemporary(l_sql,true);
--|   for sz in 1 .. l_thousands.count
--|   loop
--|     l_sql := 'select count(*) from t where x in (1';
--|     for thou in 0 .. l_thousands(sz)-1
--|     loop
--|       l_chunk := null;
--|       for i in 2 .. 1000
--|       loop
--|          l_chunk := l_chunk || ','||(thou*1000+i);
--|       end loop;
--|       l_chunk := l_chunk || ') or x in (0';
--|       dbms_lob.writeappend(l_sql, length(l_chunk), l_chunk);
--|     end loop;
--|     dbms_lob.writeappend(l_sql, 1,')');
--|     l_ts := localtimestamp;
--|     execute immediate l_sql into l_res;
--|     dbms_output.put_line(l_thousands(sz) ||'k :'||(localtimestamp-l_ts));
--|   end loop;
--| end;

pause

--| SQL> declare
--|   2    l_sql clob;
--|   3    l_chunk clob;
--|   4    l_res int;
--|   5    l_thousands sys.odcinumberlist :=
--|   6        sys.odcinumberlist(65,66);
--|   7
--|   8    l_ts timestamp;
--|   9  begin
--|  10    dbms_lob.createtemporary(l_sql,true);
--|  11    for sz in 1 .. l_thousands.count
--|  12    loop
--|  13      l_sql := 'select count(*) from t where x in (1';
--|  14      for thou in 0 .. l_thousands(sz)-1
--|  15      loop
--|  16        l_chunk := null;
--|  17        for i in 2 .. 1000
--|  18        loop
--|  19           l_chunk := l_chunk || ','||(thou*1000+i);
--|  20        end loop;
--|  21        l_chunk := l_chunk || ') or x in (0';
--|  22        dbms_lob.writeappend(l_sql, length(l_chunk), l_chunk);
--|  23      end loop;
--|  24      dbms_lob.writeappend(l_sql, 1,')');
--|  25      l_ts := localtimestamp;
--|  26      execute immediate l_sql into l_res;
--|  27      dbms_output.put_line(l_thousands(sz) ||'k :'||(localtimestamp-l_ts));
--|  28    end loop;
--|  29  end;
--|  30  /
--| 65k :+000000000 00:02:13.153000000
--| declare
--| *
--| ERROR at line 1:
--| ORA-00913: too many values
--| ORA-06512: at line 26


