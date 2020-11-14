col name format a50 trunc

select name, PHYRDS, PHYWRTS
from v$filestat, v$datafile
where v$filestat.FILE# = v$datafile.FILE#
order by 2
/
