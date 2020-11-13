-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
select 'create index '||owner||'.'||replace(constraint_name,'FK','IF')||' on '||table_name||' ( ' ||
      max(decode(pos,1,column_name))||
      max(decode(pos,2,','||column_name))||
      ') tablespace tote_i02;'
from (      
select * 
from (
select /*+ ordered */
  n.name  constraint_name,
  u.name owner,
  u.name ||'.'|| o.name  table_name,
  c.name  column_name,
  row_number() over ( partition by n.name, u.name ||'.'|| o.name order by cc.pos# ) as pos
from
  (
    select /*+ ordered */ distinct
      cd.con#,
      cc.obj#
    from
      sys.cdef$  cd,
      sys.ccol$  cc,
      sys.tab$  t
    where
      cd.type# = 4 and      -- foriegn key
      cc.con# = cd.con# and
      t.obj# = cc.obj# and
      bitand(t.flags, 6) = 0 and  -- table locks enabled
      not exists (      -- column not indexed
  select
    null
  from
    sys.icol$  ic,
          sys.ind$  i
  where
    ic.bo# = cc.obj# and
    ic.intcol# = cc.intcol# and
    ic.pos# = cc.pos# and
          i.obj# = ic.obj# and
          bitand(i.flags, 1049) = 0 -- index must be valid
      )
  )  fk,
  sys.obj$  o,
  sys.user$  u,
  sys.ccol$  cc,
  sys.col$  c,
  sys.con$  n
where
  o.obj# = fk.obj# and
  o.owner# != 0 and     -- ignore SYS
  u.user# = o.owner# and
  cc.con# = fk.con# and
  c.obj# = cc.obj# and
  c.intcol# = cc.intcol# and
  n.con# = fk.con#   
order by
  2, 1, 4
)
where owner in ('TOTE','SETL','POMS','ACCT')
)
group by owner, replace(constraint_name,'FK','IF'), table_name
order by 1
/
