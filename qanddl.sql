REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
set long 500000
set longchunksize 32768
set verify off
WITH input_json AS (
  SELECT dbms_developer.GET_METADATA(upper('&1'),user,'TABLE','basic') AS doc
  FROM dual
),
parsed AS (
  SELECT
    rownum r,
    jt.*
  FROM input_json d
  CROSS APPLY JSON_TABLE(d.doc, '$'
    COLUMNS (
      table_name   VARCHAR2(128) PATH '$.objectInfo.name',
      schema_name  VARCHAR2(128) PATH '$.objectInfo.schema',
      NESTED PATH '$.objectInfo.columns[*]'
      COLUMNS (
        col_name     VARCHAR2(128) PATH '$.name',
        not_null_flag VARCHAR2(5) PATH '$.notNull',
        data_type    VARCHAR2(60) PATH '$.dataType.type',
        precision    NUMBER PATH '$.dataType.precision',
        scale        NUMBER PATH '$.dataType.scale',
        length       NUMBER PATH '$.dataType.length',
        size_units   VARCHAR2(10) PATH '$.dataType.sizeUnits',
        ts_precision NUMBER PATH '$.dataType.fractionalSecondsPrecision',
        dy_precision NUMBER PATH '$.dataType.dayPrecision',
        yr_precision NUMBER PATH '$.dataType.yearPrecision'
      )
    )
  ) jt
)
select stmt
from (
select 0 x , 'create table ' || schema_name || '.' || table_name || ' (' stmt
from parsed
where r = 1
union all
select r,
  case when r = 1 then ' ' else  ',' end ||
    rpad(col_name,30) || ' ' ||
    case 
      when data_type in ('NUMBER','FLOAT','BINARY_DOUBLE','BINARY_FLOAT') then
        case
          when scale is not null then
            data_type||'(' || precision || ',' || scale || ')'
          when precision is not null then
            data_type||'(' || precision || ')'
          else
            data_type
        end
      when data_type in ('VARCHAR2','CHAR','NVARCHAR2','RAW') then
        data_type ||'('|| length ||
        case when size_units is not null then ' ' || size_units else '' end || ')'
      when data_type like 'TIMESTAMP%' then
        replace(case when ts_precision is not null then replace(data_type,'TIMESTAMP','TIMESTAMP('||ts_precision||')') else data_type end,'TIMEZONE','TIME ZONE') 
      when data_type like 'INTERVAL YEAR%' then
        case when yr_precision is not null then replace(data_type,'YEAR','YEAR('||yr_precision||')') else data_type end 
      when data_type like 'INTERVAL DAY%' then
        replace(case when dy_precision is not null then replace(data_type,'DAY','DAY('||dy_precision||')') else data_type end,'SECONDS','SECOND')
      else data_type
    end ||
    case when not_null_flag = 'true' then ' not null' end  as stmt
from parsed
union all
select 99999, ');' 
)
order by x;
