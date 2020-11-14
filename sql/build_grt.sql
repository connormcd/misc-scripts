accept owner char prompt 'Owner ? '
select 'grant select on '||object_name||' to &owner._user;'
from user_objects
where object_type = 'SEQUENCE'
union all
select 'grant insert,update,delete,select on '||object_name||' to &owner._user;'
from user_objects
where object_type in ('TABLE','VIEW')
union all
select 'grant execute on '||object_name||' to &owner._user;'
from user_objects
where object_type in ('PACKAGE','PROCEDURE','FUNCTION');
