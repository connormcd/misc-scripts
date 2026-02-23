clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
clear screen
set termout off
col department_name format a20
col city format a10
col country_name format a30
set termout on
set echo off
prompt |  
prompt |  
prompt |         _  ____ _____ _   _    _______ ____       ____  _   _ ______ 
prompt |        | |/ __ \_   _| \ | |  |__   __/ __ \     / __ \| \ | |  ____|
prompt |        | | |  | || | |  \| |     | | | |  | |   | |  | |  \| | |__   
prompt |    _   | | |  | || | | . ` |     | | | |  | |   | |  | | . ` |  __|  
prompt |   | |__| | |__| || |_| |\  |     | | | |__| |   | |__| | |\  | |____ 
prompt |    \____/ \____/_____|_| \_|     |_|  \____/     \____/|_| \_|______|
prompt |                                                                      
prompt |                                                                      
prompt |                                                            
pause
set echo on
clear screen
--
-- For the dinosaurs :-)
--
select e.first_name, 
       d.department_name,
       l.city,
       c.country_name,
       e.salary
from   hr.employees e,
       hr.departments d,
       hr.locations l,
       hr.countries c
where  e.department_id = d.department_id(+)
and    d.location_id   = l.location_id  (+)
and    l.country_id    = c.country_id   (+)
and    e.salary        > 15000;
pause
clear screen
select e.first_name, 
       d.department_name,
       l.city,
       c.country_name,
       e.salary
from   hr.employees e
  LEFT OUTER JOIN 
       hr.departments d
         on e.department_id = d.department_id
  LEFT OUTER JOIN
       hr.locations l
         on d.location_id = l.location_id
  LEFT OUTER JOIN
       hr.countries c
         on l.country_id  = c.country_id
where e.salary > 15000;
pause
clear screen
select e.first_name, 
       d.department_name,
       l.city,
       c.country_name,
       e.salary
from   hr.employees e
#pause
JOIN TO ONE (hr.departments d,
             hr.locations l,
             hr.countries c)
where e.salary > 15000;       
pause
clear screen
select e.first_name, 
       d.department_name,
       l.city,
       c.country_name,
       e.salary
from   hr.employees e,
       hr.departments d,
       hr.locations l,
       hr.countries c
where  e.department_id = d.department_id(+)
and    d.location_id   = l.location_id  (+)
and    l.country_id    = c.country_id   -- INNER
and    e.salary > 15000;
pause
clear screen
select e.first_name, 
       d.department_name,
       l.city,
       c.country_name,
       e.salary
from   hr.employees e     
join to one (hr.departments d,
       hr.locations l INNER JOIN
       hr.countries c)
where e.salary > 15000;     
pause Done
