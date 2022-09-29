REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is very likely you'll need to edit the script for correct usernames/passwords etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 
REM Squirrel data: https://data.cityofnewyork.us/api/views/vfnx-vebw/rows.csv?accessType=DOWNLOAD
REM


drop table squirrels purge;

create table squirrels (
 X number
,Y number
,Unique_Squirrel_ID varchar2(20)
,Hectare varchar2(5)
,Shift varchar2(3)
,SightingDate varchar2(12)
,Hectare_Squirrel_Number number
,Age varchar2(10)
,Primary_Fur_Color varchar2(30)
,Highlight_Fur_Color varchar2(30)
,Combination_of_Primary_and_Highlight_Color varchar2(100)
,Color_notes varchar2(128)
,Location varchar2(20)
,Above_Ground_Sighter_Measurement varchar2(10)
,Specific_Location varchar2(100)
,Running varchar2(8)
,Chasing varchar2(8)
,Climbing varchar2(8)
,Eating varchar2(8)
,Foraging varchar2(8)
,Other_Activities varchar2(128)
,Kuks varchar2(8)
,Quaas varchar2(8)
,Moans varchar2(8)
,Tail_flags varchar2(8)
,Tail_twitches varchar2(8)
,Approaches varchar2(8)
,Indifferent varchar2(8)
,Runs_from varchar2(8)
,Other_Interactions varchar2(128)
,Lat_Long varchar2(90)
)
organization external (
  type oracle_loader
  default directory temp
  access parameters (
    records delimited by newline
    skip 1
    fields terminated by ',' optionally enclosed by '"'
    missing field values are null
    (
      x
      ,y
      ,unique_squirrel_id
      ,hectare
      ,shift
      ,sightingdate
      ,hectare_squirrel_number
      ,age
      ,primary_fur_color
      ,highlight_fur_color
      ,combination_of_primary_and_highlight_color
      ,color_notes
      ,location
      ,above_ground_sighter_measurement
      ,specific_location
      ,running
      ,chasing
      ,climbing
      ,eating
      ,foraging
      ,other_activities
      ,kuks
      ,quaas
      ,moans
      ,tail_flags
      ,tail_twitches
      ,approaches
      ,indifferent
      ,runs_from
      ,other_interactions
      ,lat_long
    )
  )
  location ('Squirrel_Data.csv')
)
reject limit unlimited;

REM select * from squirrels;

create or replace view v_squirrels as
select 
      x
      ,y
      ,unique_squirrel_id
      ,hectare
      ,shift
      ,to_date(sightingdate,'MMDDYYYY') sightingdate
      ,hectare_squirrel_number
      ,age
      ,primary_fur_color
      ,highlight_fur_color
      --,combination_of_primary_and_highlight_color
      ,color_notes
      ,location
      ,case when lower(above_ground_sighter_measurement) != 'false' then to_number(above_ground_sighter_measurement) end above_ground_sighter_measurement
      ,specific_location
      ,case when running = 'false' then 'N' else 'Y' end running
      ,case when chasing = 'false' then 'N' else 'Y' end chasing
      ,case when climbing = 'false' then 'N' else 'Y' end climbing
      ,case when eating = 'false' then 'N' else 'Y' end eating
      ,case when foraging = 'false' then 'N' else 'Y' end foraging
      ,other_activities
      ,case when kuks = 'false' then 'N' else 'Y' end kuks
      ,case when quaas = 'false' then 'N' else 'Y' end quaas
      ,case when moans = 'false' then 'N' else 'Y' end moans
      ,case when tail_flags = 'false' then 'N' else 'Y' end tail_flags
      ,case when tail_twitches = 'false' then 'N' else 'Y' end tail_twitches
      ,case when approaches = 'false' then 'N' else 'Y' end approaches
      ,case when indifferent = 'false' then 'N' else 'Y' end indifferent
      ,case when runs_from = 'false' then 'N' else 'Y' end runs_from
      ,other_interactions
      ,sdo_geometry(2001,4326,sdo_point_type(y, x, NULL),NULL,NULL) lat_long
from squirrels;


