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
set define off
undefine 1
host ( echo select '^&1' from dual; > c:\tmp\myscript.sql )

host ( echo set termout off   > c:\tmp\myscript19.sql )
host ( echo set ver off       >> c:\tmp\myscript19.sql )
host ( echo column p1 new_value 1 >> c:\tmp\myscript19.sql )
host ( echo select null as p1 from dual where 1 = 2; >> c:\tmp\myscript19.sql )
host ( echo set termout on >> c:\tmp\myscript19.sql )
host ( echo select nvl^('^&1', 'default'^) from dual; >> c:\tmp\myscript19.sql )

clear screen
set define '&'
set verify off
set termout on
set echo on
clear screen
host cat c:\tmp\myscript.sql
pause
@c:\tmp\myscript.sql hello
pause
undefine 1
pause
@c:\tmp\myscript.sql 
pause
undefine 1
set define off
host ( echo select nvl^('^&1','default'^) from dual; > c:\tmp\myscript.sql )
set define '&'
clear screen
host cat c:\tmp\myscript.sql
pause
@c:\tmp\myscript.sql 
pause
undefine 1
set define off
host ( echo argument 1 default 'default' > c:\tmp\myscript.sql )
host ( echo select '^&1' from dual; >> c:\tmp\myscript.sql )
set define '&'
clear screen
host cat c:\tmp\myscript.sql
pause
@c:\tmp\myscript.sql provided
pause
undefine 1
pause
@c:\tmp\myscript.sql 

--
-- 23ai instant client is available (don't need 23ai database)
--
pause
undefine 1
clear screen
host cat c:\tmp\myscript19.sql
pause
@c:\tmp\myscript19.sql provided
pause
undefine 1
@c:\tmp\myscript19.sql 
undefine 1
