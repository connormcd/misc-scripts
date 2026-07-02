.

set termout off
def _pr_tmpfile=x:\tmp\pr.out
store set &_pr_tmpfile.set replace
set termout on
set serverout on size 1000000 termout off echo off
save &_pr_tmpfile replace
variable c123123 clob
set termout on

0 dbms_utility.expand_sql_text(q'\
0 begin

999999 \'
999999 ,:c123123); end;;
/
set long 1000000
print c123123

set termout off
@&_pr_tmpfile.set
get &_pr_tmpfile nolist
host del &_pr_tmpfile 
set termout on

