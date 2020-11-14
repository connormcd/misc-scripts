col name format a40
select name, count
from sys.x_$kcbfwait, v$datafile
where indx + 1 = file#;
