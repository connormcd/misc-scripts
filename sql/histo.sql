-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
column hist format a40
                         
define TNAME=&1
define CNAME=&2
define BUCKETS=&3
                                                                                          
                         
select wb,
       cnt,
       to_char(round( 100*cnt/(max(cnt) over ()),2),'999.00') rat,
       rpad( '*', 40*cnt/(max(cnt) over ()), '*' ) hist
  from (
select wb,
       count(*) cnt
  from (
select width_bucket( r, 0, (select count(distinct &cname) from &tname where &cname is not null)+1, &buckets) wb
 from (
select dense_rank() over (order by &cname) r
  from &tname
      )
      )
group by wb
      )
 order by wb
/
