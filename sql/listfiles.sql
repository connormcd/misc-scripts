select member from v$logfile
union all
select name from v$controlfile
union all
select name from v$datafile;
