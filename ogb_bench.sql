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
connect ogb/ogb@YOURDB
set echo on
set serverout on
exec benchmark.init(&1)

select seed 
from results 
where seed = &1
for update;

exec benchmark.run(&1)

host sleep 5
exit

