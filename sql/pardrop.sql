@drop par
@clean
set echo on
create table par ( 
  x int,
  y int)
partition by range ( x ) 
( 
  partition p1 values less than ( 1000 ),
  partition p2 values less than (2000)
);

insert into par
select rownum, rownum
from dual connect
by level <= 1999;

commit;

pause

set termout off
clear screen

begin
DBMS_SCHEDULER.drop_job('pardrop',force=>true);
exception when others then null;
end;
/

BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'pardrop',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'begin delete from par where x = 1 and rownum = 1; dbms_lock.sleep(60); end;',
    start_date      => SYSTIMESTAMP,
    enabled         => TRUE);
END;
/

set termout on
clear screen

alter session set ddl_lock_timeout = 300;

pause

alter table par drop partition p1;
set echo off
