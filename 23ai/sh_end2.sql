clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set termout on
set echo on
set lines 60
clear screen
desc t
pause
show user
pause
select global_name from global_name;
pause
update t set col = col + 5
where pk = 1





pause
/
pause
commit;
pause
select * from t;
pause
--
-- session 1
--
