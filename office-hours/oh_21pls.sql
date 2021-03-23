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
conn USERNAME/PASSWORD@//192.168.1.183/pdb1
set termout on
set echo on
clear screen

REM =============================
REM |                           |
REM |  19c and before           |
REM |                           |
REM =============================
set serverout on
begin
  for i in 1 ..10 loop
    dbms_output.put_line(i);
  end loop;
  for i in 100..110 loop
    dbms_output.put_line(i);
  end loop;
  for i in 200..210 loop
    dbms_output.put_line(i);
  end loop;
end;
.
pause
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================

begin
  for i in 1 ..10, 100..110, 200..210 loop
    dbms_output.put_line(i);
  end loop;
end;
.
pause
/
pause
clear screen
REM =============================
REM |                           |
REM |  19c and before           |
REM |                           |
REM =============================


begin
  for i in 1 .. 20 loop
     if mod(i,3)=1 then
       dbms_output.put_line(i);
     end if;
  end loop;
end;
.
pause
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================
begin
  for i in 1 .. 20 by 3 loop
     dbms_output.put_line(i);
  end loop;
end;
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================

begin
  for i in 1 .. 10 by 0.5 loop
    dbms_output.put_line(i);
  end loop;
end;
/
pause
begin
  for i number(3,1) in 1 .. 10 by 0.5 loop
    dbms_output.put_line(i);
  end loop;
end;
.
pause
/
pause

clear screen
REM =============================
REM |                           |
REM |  19c and before           |
REM |                           |
REM =============================

declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
begin
  for i in 1 .. 10 loop
    s1(i) := i*10;
  end loop;
end;
/
pause
declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
begin
  s1 := num_list(1=>10,2=>20,3=>30,4=>40,5=>50,
                 6=>60,7=>70,8=>80,9=>90,10=>100);
end;
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================
declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
begin
  s1 := num_list(10,20,30,40,50,60,70,80,90,100);
end;
/
pause

clear screen
REM =============================
REM |                           |
REM |  19c and before           |
REM |                           |
REM =============================

declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
  s2   num_list;
begin
  for i in 1 .. 10 loop
    s1(i) := i*10;
  end loop;
  
  for i in 1 .. 10 loop
    if mod(i,2) = 0 then s2(i) := s1(i); end if;
  end loop;
  for i in 1 .. 10 loop
    if s2.exists(i) then
      dbms_output.put_line(i||'='||s2(i));
    else
      dbms_output.put_line(i||' not exists');
    end if;
  end loop;
end;
.
pause
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================
declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
  s2   num_list;
begin
  s1 := num_list(1,2,3,4,5,6,7,8,9,10);
  s2 := num_list(for i in 2 .. 10 by 2 => s1(i));
  
  for i in 1 .. 10 loop
    if s2.exists(i) then
      dbms_output.put_line(i||'='||s2(i));
    else
      dbms_output.put_line(i||' not exists');
    end if;
  end loop;
end;
.
pause
/
pause

clear screen
REM =============================
REM |                           |
REM |  19c and before           |
REM |                           |
REM =============================

declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
  s2   num_list;
  idx  int;
begin
   
  s2 := num_list(2=>20,4=>40,6=>60,8=>80,10=>100);
  
  idx := s2.first;
  loop
    if idx is not null then
      dbms_output.put_line(idx||'='||s2(idx));
    else
      exit;
    end if;
    idx := s2.next(idx);
  end loop;
end;
.
pause
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================
declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
  s2   num_list;
begin
  s1 := num_list(10,20,30,40,50,60,70,80,90,1000);
  s2 := num_list(for i in 2 .. 10 by 2 => s1(i));
  
  for idx in indices of s2 loop
      dbms_output.put_line(idx||'='||s2(idx));
  end loop;
end;
/
pause
clear screen
declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
  s2   num_list;
begin
  s1 := num_list(10,20,30,40,50,60,70,80,90,1000);
  s2 := num_list(for i in 2 .. 10 by 2 => s1(i));
  
  for idx in values of s2 loop
      dbms_output.put_line(idx);
  end loop;
end;
/
pause
clear screen
declare
  type num_list is table of int index by pls_integer;
  s1   num_list;
  s2   num_list;
begin
  s1 := num_list(10,20,30,40,50,60,70,80,90,1000);
  s2 := num_list(for i in 2 .. 10 by 2 => s1(i));
  
  for x,y in pairs of s2 loop
      dbms_output.put_line(x||','||y);
  end loop;
end;
/
pause

clear screen
REM =============================
REM |                           |
REM |  19c and before           |
REM |                           |
REM =============================

declare
  bits int := 739;
begin
  for i in 0 .. 10 loop
    if bitand(bits, power(2,i)) > 0 then
      dbms_output.put_line(power(2,i));
    end if;
  end loop;
end;
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================
declare
  bits int := 739;
begin
  for power2 in 1, repeat power2*2 while power2 <= 1024 loop
    if bitand(bits, power2) > 0 then
      dbms_output.put_line(power2);
    end if;
  end loop;
end;
/
pause
clear screen
begin
 for i in 1 .. 10,
          i+1 while i<5,
          6..15 by trunc(i/4),
          i .. i+10 when mod(i,3) = 0
 loop
   dbms_output.put_line(i);
 end loop;
end;
/
pause
clear screen
REM =============================
REM |                           |
REM |  19c and before           |
REM |                           |
REM =============================
variable rc refcursor
exec open :rc for select empno from emp;

declare
  type rec is record ( r1 number );
  type rec_list is table of rec index by pls_integer;
  r rec_list;
begin
  loop
    fetch :rc bulk collect into r limit 10;
    for i in 1 .. r.count loop
      dbms_output.put_line(r(i).r1);
    end loop;
    exit when :rc%notfound;
  end loop;
end;
.
pause
/
pause
clear screen
REM =============================
REM |                           |
REM |  21 and beyond            |
REM |                           |
REM =============================
variable rc refcursor
exec open :rc for select empno from emp;

begin
  for r number in values of :rc loop
    dbms_output.put_line(r);
  end loop;
end;
.
pause
/
pause
clear screen
variable rc refcursor
exec open :rc for select empno, ename from emp;

declare
  type rec is record ( r1 number, r2 varchar2(30));
begin
  for r rec in values of :rc loop
    dbms_output.put_line(r.r1||','||r.r2);
  end loop;
end;
/
