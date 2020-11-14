select distinct regexp_replace(program,'\(.*') pgm, terminal from v$session
where terminal is not null
order by 2,1;