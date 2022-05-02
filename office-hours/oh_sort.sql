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
@drop t
set termout on
set echo on
create table t as
select column_value x from table (sys.odcivarchar2list
   ('1'
   ,'10'
   ,'J0501B-T0516T 1 of 1'
   ,'KBA41901108 1 of 1'
   ,'1111'
   ,'11ABC'
   ,'12'
   ,'PNL18186 3 of 3'
   ,'11'
   ,'SM-AHR18'
   ,'111'
   ,'1ABC'
   ,'222'
   ,'22ABC'
   ,'2ABC'
   ,'2'
   ,'22'
   ,'3'
   ,'PNL18186 1of 3'
   ,'PNL18186 2 of 3'
   ,'4'
   ,'5'
   ,'T1GC042TLR10C3A'));
pause
clear screen
select * from t;
pause
clear screen
select * from t
order by 1;
pause
clear screen
select x
from t
order by 
  case 
    when replace(translate(trim(x),'0123456789','0'),'0') is null 
    then lpad(x,20) 
  end,
  x;
pause
clear screen

select x
from t
order by 
  case 
    when regexp_like(x,'^([0-9]+)$') 
    then lpad(x,20) 
    else x 
  end;
pause
clear screen

select x
from t
order by 
  case 
  when regexp_like(x,'^[0-9]+$') 
  then lpad(x,20,'0') 
  else 
    case 
      when regexp_like(x,'^[0-9]+.*') 
      then lpad(x,20,'1')
      else lpad(x,20,'2')
    end
end;
pause
clear screen

select x
from t
order by 
  case 
    when replace(translate(trim(x),'0123456789','0'),'0') is null 
    then to_number(X) 
  end,
  x;
pause
clear screen
     
  
select x
from t
order by to_number(x default 9999999 on conversion error),
  x;
pause
clear screen
  
select x
from t
order by 
  case when validate_conversion(x as number) = 1 then to_number(x) end,
  x;
         
