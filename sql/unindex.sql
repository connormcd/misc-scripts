column columns format a20 word_wrapped
column table_name format a30 word_wrapped

select decode( b.table_name, NULL, '****', 'ok' ) Status, 
           a.table_name, a.columns, b.columns
from 
( select a.table_name, a.constraint_name, 
             max(decode(position, 1,     substr(column_name,1,30),NULL)) || 
             max(decode(position, 2,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position, 3,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position, 4,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position, 5,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position, 6,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position, 7,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position, 8,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position, 9,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position,10,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position,11,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position,12,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position,13,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position,14,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position,15,', '||substr(column_name,1,30),NULL)) || 
             max(decode(position,16,', '||substr(column_name,1,30),NULL)) columns
    from user_cons_columns a, user_constraints b
   where a.constraint_name = b.constraint_name
     and b.constraint_type = 'R'
   group by a.table_name, a.constraint_name ) a, 
( select table_name, index_name, 
             max(decode(column_position, 1,     substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 2,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 3,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 4,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 5,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 6,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 7,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 8,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position, 9,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position,10,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position,11,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position,12,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position,13,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position,14,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position,15,', '||substr(column_name,1,30),NULL)) || 
             max(decode(column_position,16,', '||substr(column_name,1,30),NULL)) columns
    from user_ind_columns 
   group by table_name, index_name ) b
where a.table_name = b.table_name (+)
  and b.columns (+) like a.columns || '%'
/
