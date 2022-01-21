create table wordle (
  w varchar2(10)
)  
organization external (
  type oracle_loader
  default directory xtmp
  access parameters (
    records delimited by newline
    fields terminated by ','
    missing field values are null
    (w char(5) )
  )
  location ('words.dat')
)
reject limit 10;
