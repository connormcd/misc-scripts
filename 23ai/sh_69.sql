clear screen
@clean
set termout off
conn dbdemo/dbdemo@db23
set termout off
clear screen
drop index trivia_ix force;
col model_name format a20
col algorithm format a15
col facts format a70 trunc
set lines 200
set pages 999
set verify off
set termout on
set echo off
prompt |
prompt |           
prompt |   
prompt |     _    ___     ______  _____  _____ _____    __      ________ _____ _______ ____  _____  
prompt |    | |  | \ \   / /  _ \|  __ \|_   _|  __ \   \ \    / /  ____/ ____|__   __/ __ \|  __ \ 
prompt |    | |__| |\ \_/ /| |_) | |__) | | | | |  | |   \ \  / /| |__ | |       | | | |  | | |__) |
prompt |    |  __  | \   / |  _ <|  _  /  | | | |  | |    \ \/ / |  __|| |       | | | |  | |  _  / 
prompt |    | |  | |  | |  | |_) | | \ \ _| |_| |__| |     \  /  | |___| |____   | | | |__| | | \ \ 
prompt |    |_|  |_|  |_|  |____/|_|  \_\_____|_____/       \/   |______\_____|  |_|  \____/|_|  \_\
prompt |                                                                                            
prompt |                                                                                            
prompt |   
prompt |   
pause
set echo on
clear screen
select pk, facts
from trivia_vec
order by vector_distance(vec,vector_embedding(doc_model using 'drink recipes' as data), cosine) 
fetch first 4 rows only;
pause
clear screen
--
-- They HAVE to be whiskey cocktails
--
--
pause
select pk, facts
from trivia_vec
order by vector_distance(vec,vector_embedding(doc_model using 'drink recipes CONTAINING WHISKEY' as data), cosine) 
fetch first 4 rows only
.
pause
/
pause
clear screen
create hybrid vector index trivia_ix 
  on trivia ( facts ) 
  parameters ( 'model DOC_MODEL VECTOR_IDXTYPE HNSW');
pause  
--
-- vector search
--
select dbms_hybrid_vector.search(
  json('{ "hybrid_index_name": "TRIVIA_IX",
          "search_text": "drink recipes",
          "vector": {"result_max": 2}}')) results
.
pause
/
pause
clear screen
--
-- text search
--
select dbms_hybrid_vector.search(
  json('{ "hybrid_index_name": "TRIVIA_IX",
          "text" : { "contains" : "sour" }}'))  results
.
pause
/
pause
clear screen
--
-- vector OR text search
--
select dbms_hybrid_vector.search(
  json('{ "hybrid_index_name": "TRIVIA_IX",
          "vector": {"search_text": "drink recipes", "result_max": 2},
          "text" : { "contains" : "sour" }
          }'))  results
.
pause
/
pause
clear screen
with t as
(
select treat(dbms_hybrid_vector.search(
  json('{ "hybrid_index_name": "TRIVIA_IX",
          "vector": {"search_text": "drink recipes", "result_max": 2},
          "text" : { "contains" : "sour" }
          }')) as json ) x
)
select t.x.chunk_text
from t t;
pause
with t as
(
select treat(dbms_hybrid_vector.search(
  json('{ "hybrid_index_name": "TRIVIA_IX",
          "vector": {"search_text": "drink recipes", "result_max": 5},
          "text" : { "contains" : "sour" }
          }')) as json ) x
)
select value
from t t, json_table(t.x.chunk_text,'$[*]' columns (value PATH '$' ));
pause
with t as
(
select treat(dbms_hybrid_vector.search(
  json('{ "hybrid_index_name": "TRIVIA_IX",
          "search_fusion" : "INTERSECT",
          "vector": {"search_text": "drink recipes"},
          "text" : { "contains" : "sour" }
          }')) as json ) x
)
select value
from t t, json_table(t.x.chunk_text,'$[*]' columns (value PATH '$' ));
pause

select * from dbms_hybrid_vector.searchpipeline(
   json('{ "hybrid_index_name": "TRIVIA_IX",
          "search_fusion" : "INTERSECT",
          "vector": {"search_text": "drink recipes"},
          "text" : { "contains" : "sour" }
          }'))
.
pause
/
pause
clear screen
select * from dbms_hybrid_vector.searchpipeline(
   json('{ "hybrid_index_name": "TRIVIA_IX",
          "search_fusion" : "INTERSECT",
          "vector": 
             {"search_text": "drink recipes",
              "search_mode": "CHUNK",
              "aggregator": "MAX",
              "result_max" : 10,
              "score_weight" : 10,
              "rank_penalty": 1,
              "accuracy" : 0,
              "filter_type" : "DEFAULT",
              "index_probes" : 0,
              "index_efsearch" : 0
             },
          "text" : 
            { "contains" : "sour" ,
              "score_weight" : 4,
              "result_max" : 10,
              "rank_penalty": 1
            },
          "filter_by" :
            { "op" : ">",
              "type": "number",
              "col": "PK",
              "func": "ABS",
              "args" : ["0"]
            }
          }'))
.
pause
/

pause Done
