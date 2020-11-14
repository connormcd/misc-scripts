set termout off
@drop t
@clean
set termout on
set echo on

create table t (pk number primary key, x number)
    partition by list (pk)
    (partition p1 values(1),
     partition p2 values(2)
    )
enable row movement;
pause

insert into t values (1, 1);
commit;
pause

merge into t 
using (select 1 idx, 2 new_val from dual
       connect by level <= 2
      ) u
on (t.x = u.idx)
when matched then
  update set pk=new_val;
  
pause
clear screen
select * from t;
select 1 idx, 2 new_val from dual
connect by level <= 2;
