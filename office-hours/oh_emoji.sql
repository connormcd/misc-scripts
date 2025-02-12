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
set echo on
select UTL_RAW.CAST_TO_VARCHAR2('F09F988A') from dual;
pause
select length(UTL_RAW.CAST_TO_VARCHAR2('F09F988A')) from dual;
pause
select 
  dbms_lob.getlength(UTL_RAW.CAST_TO_VARCHAR2('F09F988A')) 
from dual;
pause
with t as (
  select UTL_RAW.CAST_TO_VARCHAR2('F09F988A') smiley from dual)
select 
  dbms_lob.getlength(smiley) ,
  length(smiley),
  lengthc(smiley),
  lengthb(smiley),
  length2(smiley),
  length4(smiley)
from t;
