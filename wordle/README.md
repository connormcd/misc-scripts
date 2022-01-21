Wordle in SQL and PLSQL

Installation
============

1) Put the words.dat file somewhere you access it as an external table
2) Adjust the paramerters in words_table.sql DDL to pick up the table, and then create the table
3) Compile the package wordle.sql and you are good to go

Playing the game 
================

1) Start a new game by running:

   SQL> EXEC PKG.NEW_GAME

which will pick a random word from the dictionary and you can start guessing

2) Make your guesses with a SQL query

   SQL> select * from pkg.guess('hello')

You will get the standard World output, ie 

- Green = correct letter, correct spot
- Yellow = correct letter, wrong spot
- Unchanged colour = incorrect letter

If you want to cheat, pass null as a guess and the code will take a guess for you


How Automated Guessing Works
============================
Based on the distribution of letters in english words, the first two guesses will always be 'raise' and 'count' because they cover the vowels and some common consonants. That gets the ball rolling. For subsequent guesses, we are building a SQL statement based on the guesses to date.  For example, asssuming a guess of 'raise' and the first letter 'r' is fully correct, and the 'e' is correct but misplaced.  That yields an SQL that could be used to find another guess, namely:

    select w
    from   wordle
    --
    -- must start with 'r'
    --
    where  w like 'r_____'
    --
    -- must contain an 'e'
    --
    and    w like '%e%'
    --
    -- but the 'e' is not in the last position
    --
    and    w not like '____e'
    --
    -- must NOT contain an 'a','i','s'
    --
    and    w not like '%a%'
    and    w not like '%i%'
    and    w not like '%s%'

That gives a list of potential next guesses. In order to pick one of these intelligently, there is also a "strength" function in the code.  When the code is first run, we stored a popularity distribution for each letter in the words.dat file.  For example, 'a' might be the popular letter ocurring 10% of the time, followed by 'e' at 9% and so on.  Thus out of the candidate words the above SQL might return, we will pass the 5 letters in the word to the strength function which sums each letter's popularity percentage to give an overall "strength" to the word.  We will opt for the strongest word first.  Obviously word popularity is different to sum-of-letters popularity, but its close enough.  So our SQL will end up like:

    select w
    from 
    (
     select w
     from   wordle
     --
     -- must start with 'r'
     --
     where  w like 'r_____'
     --
     -- must contain an 'e'
     --
     and    w like '%e%'
     --
     -- but the 'e' is not in the last position
     --
     and    w not like '____e'
     --
     -- must NOT contain an 'a','i','s'
     --
     and    w not like '%a%'
     and    w not like '%i%'
     and    w not like '%s%'
     order by strength(w) desc
    )
    where rownum = 1

Example Run
===========
Clearly without colours, this is a little hard to convey, but I'll let you know in advance that the word was "units"

    SQL> exec pkg.new_game;

    PL/SQL procedure successfully completed.

    SQL> select * from pkg.guess();

    COLUMN_VALUE
    ----------------------------------------------------------------------------------------------------------------------------------
    r a i s e

    1 row selected.

    SQL> select * from pkg.guess();

    COLUMN_VALUE
    ----------------------------------------------------------------------------------------------------------------------------------
    r a i s e
    c o u n t

    2 rows selected.

    SQL> select * from pkg.guess();

    COLUMN_VALUE
    ----------------------------------------------------------------------------------------------------------------------------------
    r a i s e
    c o u n t
    n u i t s

    3 rows selected.

    --
    -- For reference, the SQL that was generated to satisfy the above guess
    -- is shown below
    --
    select w from ( select w from wordle where 1=1
     and w like '__i__'
     and w like '%s%'
     and w not like '___s_'
     and w like '%u%'
     and w not like '__u__'
     and w like '%n%'
     and w not like '___n_'
     and w like '%t%'
     and w not like '____t'
     and w not like '%r%'
     and w not like '%a%'
     and w not like '%e%'
     and w not like '%c%'
     and w not like '%o%' 
     and w != 'raise' 
     and w != 'count' order by pkg.strength(w) desc ) 
    where rownum = 1

    SQL> select * from pkg.guess();

    COLUMN_VALUE
    ----------------------------------------------------------------------------------------------------------------------------------
    r a i s e
    c o u n t
    n u i t s
    u n i t s
    COMPLETED!!!



Standard disclaimer - anything in here can be used at your own risk.

No warranty or liability etc etc etc. See the license.
