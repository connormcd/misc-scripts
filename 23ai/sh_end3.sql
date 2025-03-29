set termout off
set feedback off
alias selectai=exec chatdb(:b1,:b2);
set cloudconfig c:\oracle\sql\Wallet_MovieStreamWorkshop.zip
connect MOVIESTREAM/watchS0meMovies#@moviestreamworkshop_low
col movie_title format a40
col title format a40
set serverout on
set echo off
clear screen
set termout on
set echo off
prompt | 
prompt | 
prompt |    ____  _   _ ______     __  __  ____  _____  ______     _______ _    _ _____ _   _  _____ 
prompt |   / __ \| \ | |  ____|   |  \/  |/ __ \|  __ \|  ____|   |__   __| |  | |_   _| \ | |/ ____|
prompt |  | |  | |  \| | |__      | \  / | |  | | |__) | |__         | |  | |__| | | | |  \| | |  __ 
prompt |  | |  | | . ` |  __|     | |\/| | |  | |  _  /|  __|        | |  |  __  | | | | . ` | | |_ |
prompt |  | |__| | |\  | |____    | |  | | |__| | | \ \| |____       | |  | |  | |_| |_| |\  | |__| |
prompt |   \____/|_| \_|______|   |_|  |_|\____/|_|  \_\______|      |_|  |_|  |_|_____|_| \_|\_____|
prompt |                                                                                             
prompt |                                                                                             
prompt | 
pro SQL> pause
pause
clear screen
set termout on
pro SQL> select banner from v$version;
select banner from v$version;
pro SQL> pause
pause
pro SQL> select table_name from user_tables order by 1
PRO  2   /
select table_name from user_tables order by 1;
pro SQL> pause
pause
clear screen
host cat c:\oracle\sql\ai_profile.txt
exec dbms_session.sleep(0.1)
pro PL/SQL procedure successfully completed.
pro 
pro SQL> pause
pause
clear screen
pro SQL> select ai 'what is tom hanks highest grossing movie' showsql
exec chatdb('what is tom hanks highest grossing movie','showsql');
pro SQL> pause
pause
pro SQL> select ai 'what is tom hanks highest grossing movie' narrate
exec chatdb('what is tom hanks highest grossing movie','narrate');
pro SQL> pause
pause
clear screen
pro SQL> select ai 'please list me 10 movies released in the early 2000s' 
exec chatdb('please list me 10 movies released in the early 2000s');
