clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
set define off
undefine 1
clear screen
set define '&'
set verify off
set termout on
set echo off
prompt |
prompt |    _____  _    _  ____  _   _ _____ _____  _____ 
prompt |   |  __ \| |  | |/ __ \| \ | |_   _/ ____|/ ____|
prompt |   | |__) | |__| | |  | |  \| | | || |    | (___  
prompt |   |  ___/|  __  | |  | | . ` | | || |     \___ \ 
prompt |   | |    | |  | | |__| | |\  |_| || |____ ____) |
prompt |   |_|    |_|  |_|\____/|_| \_|_____\_____|_____/ 
prompt |                                                  
pause
set echo on
clear screen
select soundex('MCDONALD') from dual;
pause
select soundex('MACDONALD') from dual;
pause
clear screen
select soundex('SMITH') from dual;
pause
select soundex('SMYTH') from dual;
pause
clear screen
select soundex('BARACK') from dual;
pause
select soundex('BARASH') from dual;
pause
select soundex('BARAYUGA') from dual;
pause
select soundex('BAROWSKI') from dual;
pause
select soundex('BERCH') from dual;
pause
select soundex('BIRES') from dual;
pause
select soundex('BORCKY') from dual;
pause
select soundex('BORREGO') from dual;
pause
select soundex('BOURKE') from dual;
pause
select soundex('BRASKI') from dual;
pause
select soundex('BREEZEE') from dual;
pause
select soundex('BROCK') from dual;
pause
select soundex('BRUCE') from dual;
pause
select soundex('BURGIO') from dual;
pause
select soundex('BURROWS') from dual;
pause
select soundex('BYRES') from dual;
pause
clear screen
select col, phonic_encode(double_metaphone,col) double_met
from ( values 
        ('BARACK'),
        ('BARASH'),
        ('BARAYUGA'),
        ('BAROWSKI'),
        ('BERCH'),
        ('BIRES'),
        ('BORCKY'),
        ('BORREGO'),
        ('BOURKE'),
        ('BRASKI'),
        ('BREEZEE'),
        ('BROCK'),
        ('BRUCE'),
        ('BURGIO'),
        ('BURROWS'),
        ('BYRES') ) names (col)

pause
/
pause
clear screen
with names (col) as ( 
    values 
    ('BARACK'),
    ('BARASH'),
    ('BARAYUGA'),
    ('BAROWSKI'),
    ('BERCH'),
    ('BIRES'),
    ('BORCKY'),
    ('BORREGO'),
    ('BOURKE'),
    ('BRASKI'),
    ('BREEZEE'),
    ('BROCK'),
    ('BRUCE'),
    ('BURGIO'),
    ('BURROWS'),
    ('BYRES') )
select a.col, b.col, fuzzy_match(levenshtein, a.col, b.col, unscaled) as fuzz
from names a, names b
where a.col != b.col

pause
/
pause

clear screen
with names (col) as ( 
    values 
    ('BARACK'),
    ('BARASH'),
    ('BARAYUGA'),
    ('BAROWSKI'),
    ('BERCH'),
    ('BIRES'),
    ('BORCKY'),
    ('BORREGO'),
    ('BOURKE'),
    ('BRASKI'),
    ('BREEZEE'),
    ('BROCK'),
    ('BRUCE'),
    ('BURGIO'),
    ('BURROWS'),
    ('BYRES') )
select a.col, b.col, fuzzy_match(bigram, a.col, b.col, unscaled) as fuzz
from names a, names b
where a.col != b.col
order by 3 desc
fetch first 12 rows only

pause
/
pause

clear screen
with names (col) as ( 
    values 
    ('BARACK'),
    ('BARASH'),
    ('BARAYUGA'),
    ('BAROWSKI'),
    ('BERCH'),
    ('BIRES'),
    ('BORCKY'),
    ('BORREGO'),
    ('BOURKE'),
    ('BRASKI'),
    ('BREEZEE'),
    ('BROCK'),
    ('BRUCE'),
    ('BURGIO'),
    ('BURROWS'),
    ('BYRES') )
select a.col, b.col, fuzzy_match(trigram, a.col, b.col, unscaled) as fuzz
from names a, names b
where a.col != b.col
order by 3 desc
fetch first 12 rows only

pause
/
pause
clear screen
with names (col) as ( 
    values 
    ('BARACK'),
    ('BARASH'),
    ('BERCH'),
    ('BARACK OBAMA'),
    ('BORCKY'),
    ('BORREGO'),
    ('BOURKE'),
    ('BURKE'),
    ('BROCK'),
    ('BROCKFORD')
    )
select a.col, b.col, fuzzy_match(whole_word_match, a.col, b.col, unscaled) as fuzz
from names a, names b
where a.col != b.col
order by 3 desc
fetch first 12 rows only

pause
/
pause
clear screen
with names (col) as ( 
    values 
    ('BARACK'),
    ('BARASH'),
    ('BERCH'),
    ('BARACK OBAMA'),
    ('BORCKY'),
    ('BORREGO'),
    ('BOURKE'),
    ('BURKE'),
    ('BROCK'),
    ('BROCKFORD')
    )
select a.col, b.col, fuzzy_match(whole_word_match, a.col, b.col, edit_tolerance 70) as lev
from names a, names b
where a.col != b.col
order by 3 desc
fetch first 12 rows only

pause
/

pause Done
