REM
REM Standard disclaimer - anything in here can be used at your own risk.
REM 
REM It is possible you'll need to edit the script for correct usernames/passwords, missing information etc.
REM 
REM No warranty or liability etc etc etc. See the license file in the git repo root
REM
REM *** USE AT YOUR OWN RISK ***
REM 


set echo on
drop table basketball purge;

create table basketball
   (    player varchar2(10) collate using_nls_comp,
        game date,
        tstamp date,
        quarter number(*,0),
        points number(*,0)
   )  ;

Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Campbell',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Zack',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Matt',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Rory',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Will',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,3);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Max',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Campbell',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Rory',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Max',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,3);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Matt',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Rory',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Campbell',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Zack',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Campbell',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Campbell',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Max',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Will',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Zack',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,3);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Zack',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,3);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,3);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Matt',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Zack',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Campbell',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,3);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Max',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,3);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Campbell',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),1,2);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Zack',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,1);
Insert into BASKETBALL (PLAYER,GAME,TSTAMP,QUARTER,POINTS) values ('Robbie',to_date('07/MAY/21','DD/MON/RR'),to_date('07/MAY/21','DD/MON/RR'),2,2);

select quarter,
           nvl2(rownum,max(player),null) player,
           nvl2(rownum,max(tstamp),null) tstamp,
           sum(points)
    from   basketball
    group by rollup(quarter,rownum)
    order by quarter,tstamp;

select quarter,player,sum(points) from  basketball
group by cube(quarter,player);

select quarter,player,sum(points)
    from   basketball
    group by grouping sets (
      (player),(quarter), () );

select qtr, player, pts
    from
      ( select quarter, player, sum(points) pts
        from basketball
        group by quarter, player ) b
    right outer join
      ( select rownum qtr from dual connect by level <= 4 ) q
    on ( q.qtr = b.quarter )
    order by 2,1;

select qtr, player, nvl(pts,0)
    from
      ( select quarter, player, sum(points) pts
        from basketball
        group by quarter, player ) b
    partition by (b.player)
    right outer join
      ( select rownum qtr from dual connect by level <= 4 ) q
    on ( q.qtr = b.quarter )
   order by 2,1;
   

select rank(13) within group ( order by pts ) ranking
    from
     ( select player, sum(points) pts
       from   basketball
       group by player
     );
    
select
      quarter,
      rank(4) within group ( order by pts )  ranking
    from
     ( select player, quarter, sum(points) pts
       from   basketball
       group by player, quarter
     )
    group by quarter
   order by 1;


drop table aust_rules purge;

  create table aust_rules
   (    player# number(*,0),
        quarter number(*,0),
        position varchar2(20) collate using_nls_comp,
        stops number(*,0),
        goals number(*,0)
   )  ;

Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (2,2,'Forward',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (3,3,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (4,4,'Defense',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (5,1,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (6,2,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (7,3,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (8,4,'Centre',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (9,1,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (10,2,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (11,3,'Forward',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (12,4,'Forward',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (13,1,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (14,2,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (15,3,'Defense',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (16,4,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (17,1,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (18,2,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (19,3,'Defense',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (20,4,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (21,1,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (22,2,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (23,3,'Centre',2,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (24,4,'Defense',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (25,1,'Defense',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (1,2,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (2,3,'Forward',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (3,4,'Centre',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (4,1,'Defense',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (5,2,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (6,3,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (7,4,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (8,1,'Centre',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (9,2,'Defense',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (10,3,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (11,4,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (12,1,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (13,2,'Centre',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (14,3,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (15,4,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (16,1,'Forward',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (17,2,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (18,3,'Centre',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (19,4,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (20,1,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (21,2,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (22,3,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (23,4,'Centre',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (24,1,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (25,2,'Defense',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (1,3,'Forward',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (2,4,'Forward',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (3,1,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (4,2,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (5,3,'Defense',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (6,4,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (7,1,'Forward',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (8,2,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (9,3,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (10,4,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (11,1,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (12,2,'Forward',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (13,3,'Centre',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (14,4,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (15,1,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (16,2,'Forward',2,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (17,3,'Forward',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (18,4,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (19,1,'Defense',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (20,2,'Defense',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (21,3,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (22,4,'Forward',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (23,1,'Centre',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (24,2,'Defense',2,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (25,3,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (1,4,'Forward',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (2,1,'Forward',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (3,2,'Centre',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (4,3,'Defense',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (5,4,'Defense',1,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (6,1,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (7,2,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (8,3,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (9,4,'Defense',2,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (10,1,'Defense',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (11,2,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (12,3,'Forward',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (13,4,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (14,1,'Defense',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (15,2,'Defense',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (16,3,'Forward',0,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (17,4,'Forward',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (18,1,'Centre',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (19,2,'Defense',2,1);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (20,3,'Defense',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (21,4,'Forward',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (22,1,'Forward',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (23,2,'Centre',0,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (24,3,'Defense',1,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (25,4,'Defense',2,0);
Insert into AUST_RULES (PLAYER#,QUARTER,POSITION,STOPS,GOALS) values (1,1,'Forward',0,0);

with
     player_total as
    ( select player#, sum(goals) goals_per_player
      from aust_rules
      group by player#
    ),
    avg_goals as
    ( select avg(goals_per_player) avg_goals
      from player_total
   )
   select *
   from player_total,
        avg_goals
   where goals_per_player > avg_goals
   order by 1;

with raw_data as (
      select qtr, player, pts
      from
        ( select quarter, player, sum(points) pts
          from basketball
          group by quarter, player ) b
      partition by (b.player)
      right outer join
        ( select rownum qtr from dual connect by level <= 4 ) q
     on ( q.qtr = b.quarter )
   )
   select
     json_arrayagg(
         json_object(key player value pts )
         order by qtr ) as results
   from raw_data;

drop table shopping purge;
drop table hardware purge;

  create table shopping
   (    item varchar2(20) collate using_nls_comp,
        weight number(*,0)
   )  ;

create table hardware
 (    item varchar2(20) collate using_nls_comp,
      weight number(*,0)
 )  ;
 
 
Insert into SHOPPING (ITEM,WEIGHT) values ('milk',1000);
Insert into SHOPPING (ITEM,WEIGHT) values ('bread',650);
Insert into SHOPPING (ITEM,WEIGHT) values ('dogfood',490);
Insert into SHOPPING (ITEM,WEIGHT) values ('biscuits',250);
Insert into SHOPPING (ITEM,WEIGHT) values ('soda',1500);
Insert into SHOPPING (ITEM,WEIGHT) values ('gin',2100);
Insert into SHOPPING (ITEM,WEIGHT) values ('apples',900);
Insert into SHOPPING (ITEM,WEIGHT) values ('bananas',1200);
Insert into SHOPPING (ITEM,WEIGHT) values ('carrots',650);
Insert into SHOPPING (ITEM,WEIGHT) values ('steak',550);
Insert into SHOPPING (ITEM,WEIGHT) values ('icecream',1240);
Insert into SHOPPING (ITEM,WEIGHT) values ('butter',450);
Insert into SHOPPING (ITEM,WEIGHT) values ('honey',370);
Insert into SHOPPING (ITEM,WEIGHT) values ('vegemite',540);
Insert into SHOPPING (ITEM,WEIGHT) values ('ketchup',290);
Insert into SHOPPING (ITEM,WEIGHT) values ('eggs',800);
Insert into SHOPPING (ITEM,WEIGHT) values ('detergent',950);
Insert into SHOPPING (ITEM,WEIGHT) values ('deodrant',220);

Insert into HARDWARE (ITEM,WEIGHT) values ('chisel',400);
Insert into HARDWARE (ITEM,WEIGHT) values ('hammer',1200);
Insert into HARDWARE (ITEM,WEIGHT) values ('chainsaw',12000);
Insert into HARDWARE (ITEM,WEIGHT) values ('screwdriver',800);
Insert into HARDWARE (ITEM,WEIGHT) values ('paint',2000);
Insert into HARDWARE (ITEM,WEIGHT) values ('rake',1500);
Insert into HARDWARE (ITEM,WEIGHT) values ('shovel',3000);
Insert into HARDWARE (ITEM,WEIGHT) values ('drill',2500);
Insert into HARDWARE (ITEM,WEIGHT) values ('padlock',800);
Insert into HARDWARE (ITEM,WEIGHT) values ('tap',750);
Insert into HARDWARE (ITEM,WEIGHT) values ('sink',2100);
Insert into HARDWARE (ITEM,WEIGHT) values ('powerwasher',9000);
Insert into HARDWARE (ITEM,WEIGHT) values ('wood',2000);
Insert into HARDWARE (ITEM,WEIGHT) values ('broom',1200);
Insert into HARDWARE (ITEM,WEIGHT) values ('vice',5000);
Insert into HARDWARE (ITEM,WEIGHT) values ('hacksaw',1200);
Insert into HARDWARE (ITEM,WEIGHT) values ('bucket',500);
Insert into HARDWARE (ITEM,WEIGHT) values ('transformer',2000);


select *
    from shopping
    match_recognize (
     order by weight desc
     measures
        classifier() bag#,
        sum(bag1.weight) bag1,
        sum(bag2.weight) bag2,
        sum(bag3.weight) bag3,
       sum(bag4.weight) bag4
   all rows per match
   pattern ( (bag1|bag2|bag3|bag4)* )
   define
      bag1 as count(bag1.*) = 1 or
        sum(bag1.weight)-bag1.weight <=
           least(sum(bag2.weight),sum(bag3.weight),sum(bag4.weight))
    , bag2 as count(bag2.*) = 1 or
        sum(bag2.weight)-bag2.weight <=
           least(sum(bag3.weight),sum(bag4.weight))
    , bag3 as count(bag3.*) = 1 or
        sum(bag3.weight)-bag3.weight <= sum(bag4.weight)
   );

with portions as
    (
select *
    from shopping
    match_recognize (
     order by weight desc
     measures
        classifier() bag#,
        sum(bag1.weight) bag1,
        sum(bag2.weight) bag2,
        sum(bag3.weight) bag3,
       sum(bag4.weight) bag4
   all rows per match
   pattern ( (bag1|bag2|bag3|bag4)* )
   define
      bag1 as count(bag1.*) = 1 or
        sum(bag1.weight)-bag1.weight <=
           least(sum(bag2.weight),sum(bag3.weight),sum(bag4.weight))
    , bag2 as count(bag2.*) = 1 or
        sum(bag2.weight)-bag2.weight <=
           least(sum(bag3.weight),sum(bag4.weight))
    , bag3 as count(bag3.*) = 1 or
        sum(bag3.weight)-bag3.weight <= sum(bag4.weight)
   )
   )
   select
     bag#,
     listagg(item,',') within group ( order by item ) as items,
     sum(weight)/1000 kg
   from portions
   group by bag#;


create or replace
function pack_and_carry(p_tab dbms_tf.table_t,
                         p_bags dbms_tf.columns_t) return clob sql_macro is
  l_sql clob;
  l_bag varchar2(1000);
  l_sum varchar2(4000);
  l_pattern varchar2(4000);
  l_cnt int := to_number(trim('"' from p_bags(1)));
begin
 for i in 1 .. l_cnt loop
   l_bag := l_bag || 'bag'||i||'|';
   l_sum := l_sum || replace('sum(bag@.weight) bag@,','@',i)||chr(10);
    if i < l_cnt then
     if i < l_cnt-1 then
       l_pattern := l_pattern || replace(',bag@ as count(bag@.*) = 1
         or sum(bag@.weight)-bag@.weight <= least(','@',i);
     else
       l_pattern := l_pattern || replace(',bag@ as count(bag@.*) = 1
         or sum(bag@.weight)-bag@.weight <= ','@',i);
     end if;
     for j in i+1 .. l_cnt loop
       l_pattern := l_pattern ||replace('sum(bag@.weight),','@',j);
     end loop;
     l_pattern := rtrim(l_pattern,',')||')'||chr(10);
   end if;
 end loop;

 l_sql := q'{
select *
from p_tab
match_recognize (
 order by weight desc
 measures
    classifier() bag#,
    ~~~
all rows per match
pattern ( (###)* )
define
   $$$
}';

  l_sql := replace(l_sql,'###',rtrim(l_bag,'|'));
  l_sql := replace(l_sql,'~~~',rtrim(l_sum,','||chr(10)));
  l_sql := replace(l_sql,'$$$',ltrim(l_pattern,','));

  return l_sql;

end;
/

select
      bag#,
      listagg(item,',') within group ( order by item ) as items,
      sum(weight)/1000 kg
    from pack_and_carry(shopping,columns("4"))
    group by bag#;

select
      bag#,
      listagg(item,',') within group ( order by item ) as items,
      sum(weight)/1000 kg
    from pack_and_carry(shopping,columns("3"))
    group by bag#;
    

select
      bag#,
      listagg(item,',') within group ( order by item ) as items,
      sum(weight)/1000 kg
    from pack_and_carry(hardware,columns("5"))
    group by bag#;
    

drop table swimming purge;

  create table swimming
   (    sess date,
        lap number(*,0),
        ela number(6,1),
        delta number(6,1) invisible generated always as (ela-60) virtual
   )  ;
   

Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),1,58.7);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),2,59.7);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),3,60.3);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),4,61.3);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),5,60.7);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),6,59.7);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),7,60.2);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),8,58.6);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),9,59.6);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),10,59.9);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),11,60.4);
Insert into SWIMMING (SESS,LAP,ELA) values (to_date('10/SEP/21','DD/MON/RR'),12,60.1);

select * from swimming
    match_recognize (
      partition by sess order by lap
      measures classifier() pattern, sum(delta) as run_tot
      all rows per match
      after match skip to next row
      pattern (off_tgt* zero)
      define zero as sum(delta) = 0
    );

    
drop table car_fuel purge;
 
 create table car_fuel
  (    dte date,
       pctfull number(*,0),
       litres number(*,0)
  ) ;


Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('01/AUG/21','DD/MON/RR'),0,45);
Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('09/AUG/21','DD/MON/RR'),20,37);
Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('13/AUG/21','DD/MON/RR'),60,22);
Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('21/AUG/21','DD/MON/RR'),20,20);
Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('26/AUG/21','DD/MON/RR'),5,60);
Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('03/SEP/21','DD/MON/RR'),15,32);
Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('11/SEP/21','DD/MON/RR'),80,15);
Insert into CAR_FUEL (DTE,PCTFULL,LITRES) values (to_date('15/SEP/21','DD/MON/RR'),60,20);  

with t as
    ( select
        car_fuel.*,
        row_number() over (order by dte ) as seq
      from car_fuel
    ),
    results(dte, pctfull, litres, dirt ,seq) as
    (
      select dte, pctfull, litres, litres*0.05 dirt, seq
     from t
     where seq = 1
     union all
     select t.dte, t.pctfull, t.litres,
            results.dirt * t.pctfull/60 + t.litres*0.05 , t.seq
     from t, results
     where t.seq - 1 = results.seq
   )
   select * from results
   order by seq;
