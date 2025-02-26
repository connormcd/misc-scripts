set termout off
store set sqlplus_settings replace
clear breaks
clear columns
clear computes
set feedback off
set verify off
set pages 0
set lines 2000
set define off
set trimspool on
set verify off
set feedback off
col seq nopri
set sqlterminator off
with comment_data as (
select v.view_name, tc.column_name, c.comments, tc.column_id, count(*) over ( partition by v.view_name) num_cols, -1 num_views
from dba_views v,
     dba_tab_columns tc,
     dba_col_comments c
where v.owner = 'APEX_240200'
and v.view_name like 'APEX%'
and v.owner = tc.owner
and v.view_name = tc.table_name
and tc.owner = c.owner
and tc.table_name = c.table_name
and tc.column_name = c.column_name
union all
select v.view_name, null, c.comments, 0 column_id, -1 num_cols, count(*) over ( ) num_views
from dba_views v,
     dba_tab_comments c
where v.owner = 'APEX_240200'
and v.view_name like 'APEX%'
and v.owner = c.owner
and v.view_name = c.table_name
)
select '<tr><td width="30%"><a href="#'||view_name||'">'||view_name||'</a></td><td>'||comments||'</td></tr>'||
       case when rownum = num_views then '</table>' end,
       '01-'||rpad(view_name,200)||'00000' seq
from comment_data
where column_id = 0
union all
select 
  case when column_id = 0 then '<h2 id="'||view_name||'">'||view_name||'</h2><p>'||comments||'&nbsp;<a href="#apextop">Back to top</a></p><table>' end||
  case when column_id > 0 then '<tr><td width="30%">'||column_name||'</td><td>'||comments||'</td></tr>' end||
  case when column_id = num_cols then '</table>' end,
  '02-'||rpad(view_name,200)||lpad(column_id,5,'0') seq
from comment_data
order by seq

spool apex_docs.html
pro <html>
pro <head>
pro <style type="text/css">
pro table {
pro     font-family: 'Oracle Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", "Helvetica Neue", Arial, sans-serif;
pro     word-wrap: break-word;
pro     font-weight: normal;
pro     box-sizing: border-box;
pro     border-spacing: 0;
pro     border-collapse: collapse;
pro     background-color: transparent;
pro     table-layout: fixed;
pro     width: 100%;
pro     min-width: 420px;
pro     font-size: 14px !important;
pro     font-style: normal;
pro     font-stretch: normal;
pro     letter-spacing: normal;
pro     line-height: 16px !important;
pro     text-align: left;
pro     color: #1a1816;
pro     border: solid 2px #eceae5;
pro }
pro 
pro tr {
pro     font-family: 'Oracle Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", "Helvetica Neue", Arial, sans-serif;
pro     word-wrap: break-word;
pro     font-weight: normal;
pro     border-spacing: 0;
pro     border-collapse: collapse;
pro     font-size: 14px !important;
pro     font-style: normal;
pro     font-stretch: normal;
pro     letter-spacing: normal;
pro     line-height: 16px !important;
pro     color: #1a1816;
pro     text-align: -webkit-left;
pro     vertical-align: top;
pro     box-sizing: border-box;
pro }
pro 
pro td {
pro     font-family: 'Oracle Sans', -apple-system, BlinkMacSystemFont, "Segoe UI", "Helvetica Neue", Arial, sans-serif;
pro     border-spacing: 0;
pro     border-collapse: collapse;
pro     vertical-align: top;
pro     box-sizing: border-box;
pro     word-wrap: break-word;
pro     border: solid 2px #eceae5;
pro     font-size: 14px !important;
pro     font-style: normal;
pro     font-stretch: normal;
pro     letter-spacing: normal;
pro     line-height: 16px !important;
pro     text-align: left;
pro     color: #1a1816;
pro     font-weight: normal;
pro     background: #ffffff;
pro     padding: 10px;
pro }
pro </style>
pro </head>
pro 
pro <body>
pro <h1 id="apextop">APEX dictionary views</h1>
pro <table>
/
pro </body></html>
spool off
set termout off
@sqlplus_settings
clear breaks
clear columns
clear computes
clear seq clear
set termout on
