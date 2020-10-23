REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 

set termout off
@drop fixes
@drop oracle_team
clear screen
set echo on
set termout on
create table oracle_team (
    pk number primary key,
    first_name varchar2(10),
    last_name varchar2(10)
);
 
insert into oracle_team (pk, first_name, last_name) values (1, 'Connor', 'Macdonald');
insert into oracle_team (pk, first_name, last_name) values (3, 'kris', 'saxon');
commit;
select * from oracle_team;
pause

clear screen
create table fixes (
    team_pk number,
    first_name varchar2(10),
    last_name  varchar2(10),
    applied    date
);
insert into fixes values (1, 'Connor', 'McDonald',sysdate);
insert into fixes values (3, 'Chris', 'Saxon',sysdate);
commit;
select * from fixes;
pause 

clear screen
merge into oracle_team target
using (select team_pk, first_name, last_name
       from fixes 
      ) source 
on (target.pk = source.team_pk)
when matched then 
update set 
    target.first_name = source.first_name,
    target.last_name = source.last_name
    
pause
/

select * from oracle_team;
pause

set termout off
@drop fixes
@drop oracle_team
clear screen
set echo on
set termout on
create table oracle_team (
    pk number primary key,
    first_name varchar2(10),
    last_name varchar2(10)
);
 
insert into oracle_team (pk, first_name, last_name) values (1, 'Connor', 'Macdonald');
insert into oracle_team (pk, first_name, last_name) values (3, 'kris', 'saxon');
commit;
pause

clear screen
select * from oracle_team;
create table fixes (
    team_pk number,
    first_name varchar2(10),
    last_name  varchar2(10),
    applied    date
);
insert into fixes values (1, 'Connor', 'Mcdonald',sysdate-1);
insert into fixes values (1, 'Connor', 'McDonald',sysdate);
insert into fixes values (3, 'Chris', 'Saxon',sysdate);
commit;
select * from fixes;

pause 

clear screen
merge into oracle_team target
using (select team_pk, first_name, last_name
       from fixes 
      ) source 
on (target.pk = source.team_pk)
when matched then 
update set 
    target.first_name = source.first_name,
    target.last_name = source.last_name
    
pause
/
pause

clear screen
select *
from 
(select team_pk, 
        first_name, 
        last_name,
        row_number() over ( partition by team_pk order by applied desc ) as r
 from fixes 
) where r = 1;
pause        
        
merge into oracle_team target
using 
( select *
  from 
  (select team_pk, 
          first_name, 
          last_name,
          row_number() over ( partition by team_pk order by applied desc ) as r
   from fixes 
  ) where r = 1               
) source 
on (target.pk = source.team_pk)
when matched then 
update set 
    target.first_name = source.first_name,
    target.last_name = source.last_name

pause
/

select * from oracle_team;

