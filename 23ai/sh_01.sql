clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
alter system set max_columns = standard;
drop user jane_doe cascade;
drop domain amex ;
@drop credit_card
@drop emp2
drop table hr.new_table purge;
alter session set group_by_position_enabled = false;
@drop t
@drop person
@drop seq
@drop myemp
create or replace
function my_plsql_func return number is
begin
  return 10;
end;
/
create sequence seq;
clear screen
set termout on
set echo off
prompt |
prompt |      _ _   _ ____ _____   ____  _____ _     _____ ____ _____ 
prompt |     | | | | / ___|_   _| / ___|| ____| |   | ____/ ___|_   _|
prompt |  _  | | | | \___ \ | |   \___ \|  _| | |   |  _|| |     | |  
prompt | | |_| | |_| |___) || |    ___) | |___| |___| |__| |___  | |  
prompt |  \___/ \___/|____/ |_|   |____/|_____|_____|_____\____| |_|  
prompt |                                                              
pause
set echo on
clear screen
set echo on
set termout on
select sysdate form dual;
pause
select sysdate frmo dual;
pause
clear screen
select sysdate;
pause
select 1;
pause
select seq.nextval;
pause 
set echo off
clear screen
--pro SQL> select sysdate from dual;
--pro select sysdate from dual
--pro                     *
--pro ERROR at line 1:
--pro ORA-00942: table or view does not exist
--pro SQL> 
--pause
--set echo on
--select sysdate from dual;
--pause Done

clear screen
set echo off
prompt |
prompt |  
prompt |           ,__                                                  _,
prompt |        \~\|  ~~---___              ,                          | \
prompt |         |      / |   ~~~~~~~|~~~~~| ~~---,                  _/,  >
prompt |        /~-_--__| |          |     \     / ~\~~/          /~| ||,'
prompt |        |       /  \         |------|   {    / /~)     __-  ',|_\,
prompt |       /       |    |~~~~~~~~|      \    \   | | '~\  |_____,|~,-'
prompt |       |~~--__ |    |        |____  |~~~~~|--| |__ /_-'     {,~
prompt |       |   |  ~~~|~~|        |    ~~\     /  `-' |`~ |~_____{/
prompt |       |   |     |  '---------,      \----|   |  |  ,' ~/~\,|`
prompt |       ',  \     |    |       |~~~~~~~|    \  | ,'~~\  /    |
prompt |        |   \    |    |       |       |     \_-~    /`~___--\
prompt |        ',   \  ,-----|-------+-------'_____/__----~~/      /
prompt |         '_   '\|     |      |~~~|     |    |      _/-,~~-,/
prompt |           \    |     |      |   |_    |    /~~|~~\    \,/
prompt |            ~~~-'     |      |     `~~~\___|   |   |    /
prompt |                '-,_  | _____|          |  /   | ,-'---~\
prompt |                    `~'~  \             |  `--,~~~~-~~,  \
prompt |                           \/~\      /~~~`---`         |  \
prompt |                               \    /                   \  |
prompt |                                \  |                     '\'
prompt |                                 `~'
pause
clear screen
set echo off
prompt |  
prompt |           ,'          ,'
prompt |         _/'          \                     ,..-''L_
prompt |    |--''              '-;__        |\     /      .,'
prompt |     \                      `--.__,'_ '----     ,-'
prompt |     `\                             \`-'\__    ,|
prompt |  ,--;/                             /     .| ,/
prompt |  \__                               '|    /  / 
prompt |    ./  _-,                         _|   
prompt |    \__/ /                        ,/        
prompt |         |                      _/
prompt |         |                    ,/
prompt |         \                   /
prompt |          |              /.-'
prompt |           \           _/                   
prompt |            |         /                      
prompt |             |        |                     
prompt |             |        |                     
prompt |              \       /                     
prompt |               |     |                
prompt |               \    _|                      
prompt |                \_,/                    
pause Done