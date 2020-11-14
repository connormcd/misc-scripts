drop table stats_pre;
create table stats_pre pctfree 0 as
select statistic#, value
from  v$mystat;
