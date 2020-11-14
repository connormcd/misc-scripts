-------------------------------------------------------------------------------
--
-- PLEASE NOTE
-- 
-- No warranty, no liability, no support.
--
-- This script is 100% at your own risk to use.
--
-------------------------------------------------------------------------------
col table_owner format a15 trunc
col ind1 format a50 word_wrapped
col ind2 format a50 word_wrapped
col MB format 999,999,999
 
break ON report skip 1
compute SUM OF MB ON report
 
WITH t AS
(
  SELECT
    table_owner,
    TABLE_NAME,
    index_name,
    index_owner,
    listagg(column_name, ',') WITHIN GROUP (ORDER BY column_position) || ',' cols
  FROM
    dba_ind_columns
  GROUP BY
    table_owner,
    TABLE_NAME,
    index_name,
    index_owner
)
SELECT
  t2.table_owner,
  t2.TABLE_NAME,
  t2.index_name,
  (SELECT SUM(bytes)/1024/1024 FROM dba_segments s WHERE s.segment_name = t2.index_name AND s.owner = t2.index_owner) MB,
  rtrim(t2.cols, ',') ind1,
  rtrim(t1.cols, ',') ind2
FROM
  t t1,
  t t2
WHERE
  t1.table_owner = t2.table_owner AND
  t1.TABLE_NAME = t2.TABLE_NAME AND
  t1.index_name <> t2.index_name AND
  t1.cols LIKE t2.cols || '%'
;

