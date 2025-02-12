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
clear screen
set termout on
set echo on
create index tab4k_ix on tab4k ( owner );
pause
create index tab8k_ix on tab8k ( owner );
pause
clear screen
set autotrace traceonly explain
pause
select * from tab8k where owner > 'TTT';
pause
select /*+ FULL(t) */ * from tab8k t where owner > 'TTT';
pause
clear screen
select * from tab4k where owner = 'TTT';
pause
select /*+ FULL(t) */ * from tab4k t where owner > 'TTT';
pause
clear screen
select * from tab8k where owner > 'SSS';
pause
select * from tab4k where owner = 'SSS';
