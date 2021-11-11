curl -o f1.gz https://ergast.com/downloads/f1db_ansi.sql.gz
gzip -dc f1.gz | sed -f f1.sed > f1_build.sql
sqlplus USER/PASS@DB @f1_wrapper.sql


