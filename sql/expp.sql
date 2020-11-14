select * 
from table(dbms_xplan.display(format=>'PARTITION  -COST -BYTES'));
