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
set termout on
clear screen
set feedback on
set echo on
declare
    procedure pc(i number, d1 number, d2 number) is
    begin
      if i <= 0 or i != d1 or i != d2 then
         raise_application_error(-20100, 'error:' || i || ' != ' || d1 || ' / ' || d2);
      end if;
    end pc;
begin
  pc(1,1,1);
  pc(2,2,2);
  pc(3,3,3);
  pc(4,4,4);
  pc(5,5,5);
  pc(6,6,6);
end;
.

pause
/
pause
