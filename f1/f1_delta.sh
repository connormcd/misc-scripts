curl -o f1.gz https://ergast.com/downloads/f1db_ansi.sql.gz
gzip -dc f1.gz | sed -f f1_delta.sed > f1delt_build.sql
# sqlplus USER/PASS@DB @f1_delta_wrapper.sql


