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
@drop t3
@drop child
@drop parent
set termout on
clear screen
set echo on

create table parent(x number primary key, y int)
partition by list(y)
subpartition by hash(x)
( partition p1 values (1)
   ( subpartition p1s1, subpartition p1s2 )
) ;
pause
insert into parent values (1,1);
insert into parent values (2,1);
pause
clear screen
create table child (x number not null,z int,
   constraint child_fk foreign key(x)
   references parent on delete cascade )
partition by reference(child_fk);
pause
insert into child values (1,10);
insert into child values (2,20);
commit;
pause
clear screen
select * from parent subpartition ( p1s1 );
pause
select * from parent subpartition ( p1s2 );
pause
select * from parent partition ( p1 );
pause
clear screen

select * from child subpartition ( p1s1 )

pause
/
pause
select * from child subpartition ( p1s2 )

pause
/
pause
select * from child partition ( p1 )

pause
/
pause
clear screen
select * from child PARTITION ( p1s1 )

pause
/
pause
select * from child PARTITION ( p1s2 )

pause
/
pause
clear screen
select table_name,composite,partition_name
from user_tab_partitions
where table_name ='PARENT';
pause
select table_name,partition_name, subpartition_name
from user_tab_subpartitions
where table_name ='PARENT';
pause
clear screen
select table_name,composite,partition_name
from user_tab_partitions
where table_name ='CHILD';
pause
select table_name,partition_name, subpartition_name
from user_tab_subpartitions
where table_name ='CHILD';
pause
set termout off
clear screen
@drop t3
@drop child
@drop parent
clear screen
set termout on

create table parent(x number primary key, y int)
partition by list(y)
subpartition by hash(x)
( partition p1 values (1)
   ( subpartition p1s1, 
     subpartition p1s2 ),
#pause   
 partition p2 values (2),
#pause 
 partition p3 values (3)
  ( subpartition p3s1, 
    subpartition p3s2, 
    subpartition p3s3, 
    subpartition p3s4 
    )
) ;
pause
create table child (x number not null,
  constraint child_fk foreign key(x)
  references parent on delete cascade )
partition by reference(child_fk);
pause

clear screen
select table_name,composite,partition_name
from user_tab_partitions
where table_name ='PARENT';
pause
select table_name,partition_name, subpartition_name
from user_tab_subpartitions
where table_name ='PARENT';
pause
clear screen
select table_name,composite,partition_name
from user_tab_partitions
where table_name ='CHILD';
pause
select table_name,partition_name, subpartition_name
from user_tab_subpartitions
where table_name ='CHILD';

