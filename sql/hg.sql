set define off
create or replace
package htmlgraph is
  type tab_vc2  is table of varchar2(255)  index by binary_integer;
  type tab_num  is table of number    index by binary_integer;
  type tab_date is table of date      index by binary_integer;
  type extrema  is record ( min_val number, max_val number , range_val number );

  v_max_width number := 200;
  v_max_height number := 200;

  procedure tspace(file_dir varchar2 default 'g:\utlfile', file_name varchar2 default 'tspace.htm');
  procedure sys_events(file_dir varchar2 default 'g:\utlfile', file_name varchar2 default 'sys_events.htm');

end;
/
show errors

create or replace
package body htmlgraph is

function style_td_align_bottom return varchar2 is
begin
 return
'<html>
<head>
<style>
<!--table
.style0
	{text-align:general;
	vertical-align:bottom;}
td
	{text-align:general;
	vertical-align:bottom;
	border:none;}
-->
</style>
</head>
<body>
<font size=1>';
end;

function get_extrema(p_numtab tab_num) return extrema is
  v_extrema extrema;
begin
  v_extrema.min_val :=  999999999999999999999;
  v_extrema.max_val := -999999999999999999999;
  for i in 1 .. p_numtab.count loop
    v_extrema.min_val := least(v_extrema.min_val,p_numtab(i));
    v_extrema.max_val := greatest(v_extrema.max_val,p_numtab(i));
  end loop;
  v_extrema.range_val := v_extrema.max_val - v_extrema.min_val;
  return v_extrema;
end;

function bar_graph(x tab_vc2,y tab_num,
                    p_data_tags boolean default false,
                    p_x_labels boolean default false) return tab_vc2 is
  v_range extrema := get_extrema(y);
  v_ymult number := v_max_height / greatest(abs(v_range.range_val),1);
  v_xmult number := round(v_max_width / greatest(x.count,1));
  v_result tab_vc2;
  v_tag varchar2(1999); 
begin
  v_result(v_result.count+1) := '<table rowpadding=0 cellpadding=0>';
  v_result(v_result.count+1) := '<tr>';
  v_result(v_result.count+1) := '<td><img src="dot_blue.gif" width=1 height='||v_max_height||'></td>';
  for j in 1 .. x.count loop
    if p_data_tags then
      v_tag := '<font size=1>'||y(j)||'<br>';
    end if;
    v_result(v_result.count+1) := '<td>'||v_tag||
                     '<img src="dot_red.gif" height='||round(v_ymult*y(j))||
                     ' width='||v_xmult||'align="bottom"></td>';
  
  end loop;
  v_result(v_result.count+1) := '</tr>';
  v_result(v_result.count+1) := '<tr>';
  v_result(v_result.count+1) := '<td colspan='||(x.count+1)||'>';
  v_result(v_result.count+1) := '<img src="dot_blue.gif" height=1 width='||v_max_width ||' align="bottom"></td>';
  v_result(v_result.count+1) := '</tr>';
  if p_x_labels then
    for i in reverse 0 .. 1 loop
      if i = 1 then
         v_result(v_result.count+1) := '<tr><td>&nbsp</td>';
      else
         v_result(v_result.count+1) := '<tr><td colspan=2>&nbsp</td>';
      end if;
      for j in 1 .. x.count loop
        if mod(j,2) = i then
          v_result(v_result.count+1) := '<td colspan=2><font size=1>'||x(j)||'</font></td>';
        end if;        
      end loop;
      v_result(v_result.count+1) := '</tr>';
    end loop;
  end if;
  v_result(v_result.count+1) := '</table>';
  return v_result;
end;

function bar_graph(x tab_date,y tab_num,format_mask varchar2 default 'DD/MM/YYYY') return tab_vc2 is
  x1 tab_vc2;
begin
  for i in 1 .. x.count loop
    x1(i) := to_char(x(i),format_mask);
  end loop;
  return bar_graph(x1,y);
end;

function col_graph(x tab_vc2,y tab_num,
                    p_data_tags boolean default false) return tab_vc2 is
  v_range extrema := get_extrema(y);
  v_xmult number := v_max_width / greatest(abs(v_range.range_val),1);
  v_result tab_vc2;
  v_tag varchar2(1999); 
begin
  v_result(v_result.count+1) := '<table rowpadding=0 cellpadding=0>';
  for j in 1 .. x.count loop
    v_result(v_result.count+1) := '<tr><td>'||x(j)||'</td>';
    v_result(v_result.count+1) := '<td><img src="dot_red.gif" width='||round(v_xmult*y(j))||
                     ' height=10 align="bottom">';
    if p_data_tags then
       v_result(v_result.count+1) := '<font size=1>'||y(j)||'</font></td></tr>';
    else
       v_result(v_result.count+1) := '</td></tr>';
    end if;
  end loop;
  v_result(v_result.count+1) := '</table>';
  return v_result;
end;

function col_graph(x tab_date,y tab_num,format_mask varchar2 default 'DD/MM/YYYY') return tab_vc2 is
  x1 tab_vc2;
begin
  for i in 1 .. x.count loop
    x1(i) := to_char(x(i),format_mask);
  end loop;
  return col_graph(x1,y);
end;


procedure tspace(file_dir varchar2 default 'g:\utlfile', file_name varchar2 default 'tspace.htm') is
  v_tspace  tab_vc2;
  v_pctused tab_num;
  f utl_file.file_type := utl_file.fopen(file_dir,file_name,'W');
  v_graph tab_vc2;
begin
  select f.tablespace_name, 1+round(100-( 100 * f.sum_bytes / d.tot_bytes )) pct_used
  bulk collect
  into v_tspace, v_pctused
  from ( select tablespace_name, sum(bytes) sum_bytes
         from dba_free_space
         group by tablespace_name ) f,
       ( select tablespace_name, sum(bytes) tot_bytes
         from dba_data_files
         group by tablespace_name ) d
  where f.tablespace_name = d.tablespace_name;
  utl_file.put_line(f,style_td_align_bottom);
  v_graph := bar_graph(v_tspace,v_pctused,true,true);
  for i in 1 .. v_graph.count loop
    utl_file.put_line(f,v_graph(i));
  end loop;
  utl_file.fclose(f);
end;

procedure sys_events(file_dir varchar2 default 'g:\utlfile', file_name varchar2 default 'sys_events.htm') is
  v_event  tab_vc2;
  v_waits tab_num;
  f utl_file.file_type := utl_file.fopen(file_dir,file_name,'W');
  v_graph tab_vc2;
begin
  select event, time_waited
  bulk collect
  into v_event, v_waits
  from v$system_event
  where time_waited > 0
  order by time_waited desc;
  utl_file.put_line(f,style_td_align_bottom);
  v_graph := col_graph(v_event, v_waits,true);
  for i in 1 .. v_graph.count loop
    utl_file.put_line(f,v_graph(i));
  end loop;
  utl_file.fclose(f);
end;


end;
/
show errors
set define on
