clear screen
@clean
set termout off
conn sys/SYS_PASSWORD@db23root as sysdba
set termout off
alter system checkpoint global;
startup force
conn dbdemo/dbdemo@db23
set termout off
@drop trivia
@drop trivia_chunked
@drop trivia_pdf
@drop pics
@drop pics_vec
col dist format 99.999999999999
create or replace
directory JSONDOCS as '/home/oracle/json';

alter system flush shared_pool;
drop table if exists trivia_vec purge;
exec dbms_vector.drop_onnx_model(model_name=>'DOC_MODEL',force=>true);
exec dbms_vector.drop_onnx_model(model_name=>'IMG_MODEL',force=>true);

col model_name format a20
col algorithm format a15
col facts format a70 trunc
create table trivia ( pk int generated as identity, facts varchar2(256));

insert into trivia (facts) values 
(q'{Atlanta is located in Georgia.}'),
(q'{Boston is located in Massachusetts.}'),
(q'{Chicago is located in Illinois.}'),
(q'{Denver is located in Colorado.}'),
(q'{Houston is located in Texas.}'),
(q'{Miami is located in Florida.}'),
(q'{Nashville is located in Tennessee.}'),
(q'{Phoenix is located in Arizona.}'),
(q'{Seattle is located in Washington.}'),
(q'{Philadelphia is located in Pennsylvania}'),
(q'{Albuquerque is located in New Mexico.}'),
(q'{Anchorage is located in Alaska.}'),
(q'{Arlington is located in Virginia.}'),
(q'{Austin is located in Texas.}'),
(q'{Baltimore is located in Maryland.}'),
(q'{Birmingham is located in Alabama.}'),
(q'{Boise is located in Idaho.}'),
(q'{Buffalo is located in New York.}'),
(q'{Charleston is located in South Carolina.}'),
(q'{Charlotte is located in North Carolina.}'),
(q'{Cleveland is located in Ohio.}'),
(q'{Columbus is located in Ohio.}'),
(q'{Dallas is located in Texas.}'),
(q'{Des Moines is located in Iowa.}'),
(q'{Detroit is located in Michigan.}'),
(q'{El Paso is located in Texas.}'),
(q'{Fort Worth is located in Texas.}'),
(q'{Fresno is located in California.}'),
(q'{Honolulu is located in Hawaii.}'),
(q'{Indianapolis is located in Indiana.}'),
(q'{Jacksonville is located in Florida.}'),
(q'{Kansas City is located in Missouri.}'),
(q'{Las Vegas is located in Nevada.}'),
(q'{Lexington is located in Kentucky.}'),
(q'{Lincoln is located in Nebraska.}'),
(q'{Little Rock is located in Arkansas.}'),
(q'{Louisville is located in Kentucky.}'),
(q'{Madison is located in Wisconsin.}'),
(q'{Memphis is located in Tennessee.}'),
(q'{Milwaukee is located in Wisconsin.}'),
(q'{Minneapolis is located in Minnesota.}'),
(q'{New Orleans is located in Louisiana.}'),
(q'{New York City is located in New York.}'),
(q'{Oakland is located in California.}'),
(q'{Oklahoma City is located in Oklahoma.}'),
(q'{Omaha is located in Nebraska.}'),
(q'{Orlando is located in Florida.}'),
(q'{Pittsburgh is located in Pennsylvania.}'),
(q'{Portland is located in Oregon.}'),
(q'{Providence is located in Rhode Island.}'),
(q'{Raleigh is located in North Carolina.}'),
(q'{Richmond is located in Virginia.}'),
(q'{Sacramento is located in California.}'),
(q'{Salt Lake City is located in Utah.}'),
(q'{San Antonio is located in Texas.}'),
(q'{San Diego is located in California.}'),
(q'{San Francisco is located in California.}'),
(q'{San Jose is located in California.}'),
(q'{Savannah is located in Georgia.}'),
(q'{Sioux Falls is located in South Dakota.}'),
(q'{Spokane is located in Washington.}'),
(q'{St. Louis is located in Missouri.}'),
(q'{St. Paul is located in Minnesota.}'),
(q'{Tampa is located in Florida.}'),
(q'{Toledo is located in Ohio.}'),
(q'{Tucson is located in Arizona.}'),
(q'{Tulsa is located in Oklahoma.}'),
(q'{Virginia Beach is located in Virginia.}'),
(q'{Washington, D.C. is located in the District of Columbia.}'),
(q'{Wichita is located in Kansas.}'),
(q'{Winston-Salem is located in North Carolina.}'),
(q'{Anchorage is located in Alaska.}'),
(q'{Bakersfield is located in California.}'),
(q'{Baton Rouge is located in Louisiana.}'),
(q'{Bellevue is located in Washington.}'),
(q'{Bend is located in Oregon.}'),
(q'{Boulder is located in Colorado.}'),
(q'{Bridgeport is located in Connecticut.}'),
(q'{Cambridge is located in Massachusetts.}'),
(q'{Cary is located in North Carolina.}'),
(q'{Chesapeake is located in Virginia.}'),
(q'{Cincinnati is located in Ohio.}'),
(q'{Coral Springs is located in Florida.}'),
(q'{Daly City is located in California.}'),
(q'{Durham is located in North Carolina.}'),
(q'{Escondido is located in California.}'),
(q'{Eugene is located in Oregon.}'),
(q'{Fayetteville is located in Arkansas.}'),
(q'{Fontana is located in California.}'),
(q'{Fort Lauderdale is located in Florida.}'),
(q'{Fremont is located in California.}'),
(q'{Garland is located in Texas.}'),
(q'{Glendale is located in Arizona.}'),
(q'{Grand Rapids is located in Michigan.}'),
(q'{Green Bay is located in Wisconsin.}'),
(q'{Greensboro is located in North Carolina.}'),
(q'{Henderson is located in Nevada.}'),
(q'{Hialeah is located in Florida.}'),
(q'{Irvine is located in California.}'),
(q'{Jersey City is located in New Jersey.}'),
(q'{Joliet is located in Illinois.}'),
(q'{Lafayette is located in Louisiana.}'),
(q'{Laredo is located in Texas.}'),
(q'{Lubbock is located in Texas.}'),
(q'{Macon is located in Georgia.}'),
(q'{Mesa is located in Arizona.}'),
(q'{Montgomery is located in Alabama.}'),
(q'{Newport News is located in Virginia.}'),
(q'{Norman is located in Oklahoma.}'),
(q'{Norwalk is located in California.}');


insert into trivia (facts) values 
(q'{Camry is made by Toyota.}'),
(q'{Accord is made by Honda.}'),
(q'{Mustang is made by Ford.}'),
(q'{Civic is made by Honda.}'),
(q'{Model S is made by Tesla.}'),
(q'{Corolla is made by Toyota.}'),
(q'{3 Series is made by BMW.}'),
(q'{A4 is made by Audi.}'),
(q'{F-150 is made by Ford.}'),
(q'{Impreza is made by Subaru.}'),
(q'{Altima is made by Nissan.}'),
(q'{Charger is made by Dodge.}'),
(q'{Outback is made by Subaru.}'),
(q'{Silverado is made by Chevrolet.}'),
(q'{Golf is made by Volkswagen.}'),
(q'{Elantra is made by Hyundai.}'),
(q'{Q5 is made by Audi.}'),
(q'{RX is made by Lexus.}'),
(q'{X5 is made by BMW.}'),
(q'{Optima is made by Kia.}'),
(q'{Cherokee is made by Jeep.}'),
(q'{Impala is made by Chevrolet.}'),
(q'{Maxima is made by Nissan.}'),
(q'{Soul is made by Kia.}'),
(q'{Forester is made by Subaru.}'),
(q'{Fusion is made by Ford.}'),
(q'{Malibu is made by Chevrolet.}'),
(q'{Passat is made by Volkswagen.}'),
(q'{CR-V is made by Honda.}'),
(q'{Highlander is made by Toyota.}'),
(q'{GLC is made by Mercedes-Benz.}'),
(q'{Rogue is made by Nissan.}'),
(q'{Jetta is made by Volkswagen.}'),
(q'{Escape is made by Ford.}'),
(q'{Sentra is made by Nissan.}'),
(q'{Explorer is made by Ford.}'),
(q'{Tiguan is made by Volkswagen.}'),
(q'{Traverse is made by Chevrolet.}'),
(q'{Tucson is made by Hyundai.}'),
(q'{RAV4 is made by Toyota.}'),
(q'{Grand Cherokee is made by Jeep.}'),
(q'{C-Class is made by Mercedes-Benz.}'),
(q'{Santa Fe is made by Hyundai.}'),
(q'{Pathfinder is made by Nissan.}'),
(q'{Sorento is made by Kia.}'),
(q'{E-Class is made by Mercedes-Benz.}'),
(q'{Pacifica is made by Chrysler.}'),
(q'{Murano is made by Nissan.}'),
(q'{CX-5 is made by Mazda.}'),
(q'{4Runner is made by Toyota.}');

insert into trivia (facts) values 
(q'{Apples are members of the rose family.}'),
(q'{Bananas are berries botanically.}'),
(q'{Cherries are packed with antioxidants.}'),
(q'{Grapes improve heart health.}'),
(q'{Watermelons are 92% water.}'),
(q'{Pineapples regenerate; you can grow a new one from the top.}'),
(q'{Strawberries have more vitamin C than oranges.}'),
(q'{Blueberries can improve memory.}'),
(q'{Kiwis aid digestion.}'),
(q'{Lemons float but limes sink.}'),
(q'{Mangos are the most consumed fruit worldwide.}'),
(q'{Oranges are a hybrid of pomelo and mandarin.}'),
(q'{Pomegranates have anti-inflammatory properties.}'),
(q'{Raspberries belong to the rose family.}'),
(q'{Blackberries aren't true berries.}'),
(q'{Coconuts are technically seeds.}'),
(q'{Papayas contain an enzyme called papain.}'),
(q'{Cranberries bounce when ripe.}'),
(q'{Grapefruits were an accidental hybrid.}'),
(q'{Avocados are high in healthy fats.}'),
(q'{Plums help regulate blood sugar.}'),
(q'{Peaches are native to China.}'),
(q'{Pears improve gut health.}'),
(q'{Dragon fruit is rich in fiber.}'),
(q'{Passion fruit is high in vitamin C.}'),
(q'{Dates are one of the oldest cultivated fruits.}'),
(q'{Figs are pollinated by wasps.}'),
(q'{Litchis contain vitamin B6.}'),
(q'{Starfruit has a tangy flavor.}'),
(q'{Gooseberries are high in antioxidants.}'),
(q'{Persimmons contain lots of manganese.}'),
(q'{Guavas boost the immune system.}'),
(q'{Apricots are good for eye health.}'),
(q'{Mulberries can be white, red, or black.}'),
(q'{Pummelos are the largest citrus fruit.}'),
(q'{Kumquats are eaten with their peel.}'),
(q'{Durians are known for their strong odor.}'),
(q'{Jackfruits can weigh over 80 pounds.}'),
(q'{Rambutans have a hairy shell.}'),
(q'{Soursops are used in beverages and desserts}');

insert into trivia (facts) values 
(q'{Cats have five toes on their front paws.}'),
(q'{A cat's nose print is unique.}'),
(q'{Cats sleep for 12-16 hours daily.}'),
(q'{The hearing of cats is superior to dogs.}'),
(q'{Cats can rotate their ears 180 degrees.}'),
(q'{A group of cats is called a clowder.}'),
(q'{Cats have 32 muscles in each ear.}'),
(q'{Whiskers help cats detect objects in the dark.}'),
(q'{A cat’s brain is 90% similar to a human’s brain.}'),
(q'{Cats have a third eyelid called a haw.}'),
(q'{Domestic cats can run up to 30 mph.}'),
(q'{Each cat's whisker pattern is unique.}'),
(q'{Cats have no collarbone.}'),
(q'{A cat can jump up to six times its length.}'),
(q'{Cats have over 100 different vocal sounds.}'),
(q'{Purring doesn’t always mean a cat is happy.}'),
(q'{A cat’s tail contains nearly 10% of its bones.}'),
(q'{Cats sweat through their paw pads.}'),
(q'{Cats use their tails for balance.}'),
(q'{A cat’s purring can heal bones.}');

insert into trivia (facts) values 
(q'{Dogs have about 1,700 taste buds.}'),
(q'{A dog’s sense of smell is 40 times better than humans.}'),
(q'{Dogs sweat through their paws.}'),
(q'{The Basenji dog doesn’t bark.}'),
(q'{Puppies are born deaf.}'),
(q'{Dogs can understand up to 250 words and gestures.}'),
(q'{Dogs have three eyelids.}'),
(q'{A dog’s nose print is unique.}'),
(q'{Dogs can be trained to detect diseases.}'),
(q'{The Chihuahua is the smallest dog breed.}'),
(q'{Greyhounds can run up to 45 mph.}'),
(q'{A dog's sense of hearing is four times better than humans.}'),
(q'{Dogs dream similarly to humans.}'),
(q'{Labradors are the most popular breed.}'),
(q'{Dogs have twice as many muscles for moving their ears as humans.}'),
(q'{The Newfoundland breed has webbed feet.}'),
(q'{Dalmatian puppies are born completely white.}'),
(q'{Dogs have an excellent sense of time.}'),
(q'{The Basenji is known as the "barkless dog."}'),
(q'{Dogs curl up to protect their organs.}');

insert into trivia (facts) values 
(q'{Paris is located in France.}'),
(q'{Rome is located in Italy.}'),
(q'{Berlin is located in Germany.}'),
(q'{Madrid is located in Spain.}'),
(q'{Lisbon is located in Portugal.}'),
(q'{Vienna is located in Austria.}'),
(q'{Athens is located in Greece.}'),
(q'{Brussels is located in Belgium.}'),
(q'{Amsterdam is located in the Netherlands.}'),
(q'{Prague is located in the Czech Republic.}'),
(q'{Warsaw is located in Poland.}'),
(q'{Budapest is located in Hungary.}'),
(q'{Copenhagen is located in Denmark.}'),
(q'{Dublin is located in Ireland.}'),
(q'{Helsinki is located in Finland.}'),
(q'{Stockholm is located in Sweden.}'),
(q'{Oslo is located in Norway.}'),
(q'{Zurich is located in Switzerland.}'),
(q'{Sofia is located in Bulgaria.}'),
(q'{Belgrade is located in Serbia.}'),
(q'{Bucharest is located in Romania.}'),
(q'{Zagreb is located in Croatia.}'),
(q'{Ljubljana is located in Slovenia.}'),
(q'{Tallinn is located in Estonia.}'),
(q'{Riga is located in Latvia.}'),
(q'{Vilnius is located in Lithuania.}'),
(q'{Bratislava is located in Slovakia.}'),
(q'{Reykjavik is located in Iceland.}'),
(q'{Tirana is located in Albania.}'),
(q'{Sarajevo is located in Bosnia and Herzegovina.}'),
(q'{Skopje is located in North Macedonia.}'),
(q'{Podgorica is located in Montenegro.}'),
(q'{Valletta is located in Malta.}'),
(q'{Luxembourg City is located in Luxembourg.}'),
(q'{Andorra la Vella is located in Andorra.}'),
(q'{Monaco is located in Monaco.}'),
(q'{San Marino is located in San Marino.}'),
(q'{Vaduz is located in Liechtenstein.}'),
(q'{Edinburgh is located in the United Kingdom.}'),
(q'{Glasgow is located in the United Kingdom.}'),
(q'{Liverpool is located in the United Kingdom.}'),
(q'{Manchester is located in the United Kingdom.}'),
(q'{Birmingham is located in the United Kingdom.}'),
(q'{Porto is located in Portugal.}'),
(q'{Seville is located in Spain.}'),
(q'{Naples is located in Italy.}'),
(q'{Marseille is located in France.}'),
(q'{Munich is located in Germany.}'),
(q'{Hamburg is located in Germany.}'),
(q'{Cologne is located in Germany.}');

insert into trivia (facts) values 
(q'{A Margarita contains Tequila, lime juice, triple sec.}'),
(q'{A Mojito contains White rum, mint leaves, lime juice, soda water.}'),
(q'{A Martini contains Gin, dry vermouth.}'),
(q'{A Old Fashioned contains Bourbon or rye whiskey, sugar, Angostura bitters.}'),
(q'{A Daiquiri contains White rum, lime juice, simple syrup.}'),
(q'{A Cosmopolitan contains Vodka, triple sec, cranberry juice, lime juice.}'),
(q'{A Manhattan contains Rye whiskey, sweet vermouth, Angostura bitters.}'),
(q'{A Whiskey Sour contains Bourbon, lemon juice, simple syrup.}'),
(q'{A Piña Colada contains White rum, coconut cream, pineapple juice.}'),
(q'{A Bloody Mary contains Vodka, tomato juice, lemon juice, Worcestershire sauce.}'),
(q'{A Mai Tai contains Light rum, dark rum, lime juice, orgeat syrup, orange curaçao.}'),
(q'{A Negroni contains Gin, Campari, sweet vermouth.}'),
(q'{A Tom Collins contains Gin, lemon juice, simple syrup, soda water.}'),
(q'{A Gin and Tonic contains Gin, tonic water.}'),
(q'{A Sidecar contains Cognac, triple sec, lemon juice.}'),
(q'{A Mint Julep contains Bourbon, mint leaves, sugar, water.}'),
(q'{A Pisco Sour contains Pisco, lime juice, simple syrup, egg white.}'),
(q'{A Sazerac contains Rye whiskey, absinthe, sugar, Peychaud’s bitters.}'),
(q'{A Gimlet contains Gin, lime juice, simple syrup.}'),
(q'{A Caipirinha contains Cachaça, lime, sugar.}'),
(q'{A French 75 contains Gin, lemon juice, simple syrup, Champagne.}'),
(q'{A Aperol Spritz contains Aperol, prosecco, soda water.}'),
(q'{A Cuba Libre contains White rum, cola, lime juice.}'),
(q'{A Bellini contains Prosecco, peach purée.}'),
(q'{A Dark 'n' Stormy contains Dark rum, ginger beer, lime juice.}'),
(q'{A Irish Coffee contains Irish whiskey, hot coffee, sugar, cream.}'),
(q'{A Tequila Sunrise contains Tequila, orange juice, grenadine.}'),
(q'{A Vesper contains Gin, vodka, Lillet Blanc.}'),
(q'{A Sea Breeze contains Vodka, cranberry juice, grapefruit juice.}'),
(q'{A Long Island Iced Tea contains Vodka, tequila, rum, gin, triple sec, lemon juice, cola.}'),
(q'{A Singapore Sling contains Gin, cherry liqueur, lime juice, soda water.}'),
(q'{A Espresso Martini contains Vodka, coffee liqueur, espresso.}'),
(q'{A Brandy Alexander contains Brandy, dark crème de cacao, cream.}'),
(q'{A Rum Punch contains Light rum, dark rum, pineapple juice, orange juice, lime juice, grenadine.}'),
(q'{A Amaretto Sour contains Amaretto, lemon juice, simple syrup.}'),
(q'{A Bee's Knees contains Gin, lemon juice, honey.}'),
(q'{A Clover Club contains Gin, raspberry syrup, lemon juice, egg white.}'),
(q'{A Paloma contains Tequila, grapefruit soda, lime juice.}'),
(q'{A Hurricane contains Light rum, dark rum, passion fruit juice, orange juice, lime juice, grenadine.}'),
(q'{A Rusty Nail contains Scotch whisky, Drambuie.}');
commit;
set termout on
set echo off
clear screen
prompt | 
prompt | 
prompt |  __      ________ _____ _______ ____  _____  
prompt |  \ \    / /  ____/ ____|__   __/ __ \|  __ \ 
prompt |   \ \  / /| |__ | |       | | | |  | | |__) |
prompt |    \ \/ / |  __|| |       | | | |  | |  _  / 
prompt |     \  /  | |___| |____   | | | |__| | | \ \ 
prompt |      \/   |______\_____|  |_|  \____/|_|  \_\
prompt |                                              
prompt |                                              
prompt | 
pause
set echo on
clear screen
select vector('[0,0]');
pause
select vector('[10,0]');
pause
select vector('[0,5]', 2, float32);
pause
select vector('[4,3,1,7,4,3,2]');
pause
clear screen
set echo off
prompt .    
prompt .    Y
prompt .    |
prompt .    4
prompt .    |
prompt .    3
prompt .    |
prompt .    2
prompt .    |
prompt .    1     @-----------@
prompt .    |
prompt .    ------1-----2-----3----4-----X
prompt .    
set echo on
pause
select 
  vector_distance(
      vector('[1, 1]'),
      vector('[3, 1]'),
      euclidean) distance;
pause    
select 
  to_number(
    vector_distance(
      vector('[1, 1]'),
      vector('[3, 1]'),
      euclidean)) distance;
pause      
clear screen
set echo off
prompt .    
prompt .    Y
prompt .    |
prompt .    4
prompt .    |
prompt .    3
prompt .    |
prompt .    2           @
prompt .    |           |
prompt .    1     @-----+           
prompt .    |
prompt .    ------1-----2-----3----4-----X
prompt .    
set echo on
pause

      select to_number(vector_distance(
          vector('[1, 1]', 2, float32),
          vector('[2, 2]',2, float32),
    euclidean)) distance;
pause

clear screen
select pk, facts
from trivia

pause
/
pause
select pk, facts
from trivia
where pk between 1 and 3
or pk between 121 and 123
or pk between 171 and 173
or pk between 221 and 223
or pk between 311 and 313;
pause
select * from trivia
where lower(facts) like '%cocktail%';
pause
clear screen
create or replace 
directory MODELS as '/home/oracle/models';
pause
begin
  dbms_vector.load_onnx_model(
     'MODELS', 
     'all-MiniLM-L6-v2.onnx', 
     'DOC_MODEL', 
     JSON('{"function":"embedding",
            "embeddingOutput":"embedding", 
            "input": {"input": ["DATA"]}}'));
end;
/
pause
select model_name, algorithm, mining_function 
from user_mining_models ;
pause
clear screen
create table trivia_vec as
select pk, facts, 
       vector_embedding(doc_model using t.facts as data) as vec
from trivia t;
pause
col vec format a40 trunc
select facts, vec
from trivia_vec
where rownum <= 10;
pause 
select vector_embedding(doc_model using 'cocktail' as data)

pause
/
pause
select pk, facts
from trivia_vec
order by vector_distance(vec , vector_embedding(doc_model using 'cocktail' as data), cosine) 
fetch first 4 rows only

pause
/
pause 
select pk, facts
from trivia_vec
order by vector_distance(vec , vector_embedding(doc_model using 'suzuki' as data), cosine) 
fetch first 4 rows only;
pause
select pk, facts
from trivia_vec
order by vector_distance(vec , vector_embedding(doc_model using 'fastest running dog' as data), cosine) 
fetch first 4 rows only;
pause
clear screen
begin
  dbms_vector.load_onnx_model(
     'MODELS', 
     'clip-vit-large-patch14_img.onnx', 
     'IMG_MODEL', 
     JSON('{"function":"embedding",
            "embeddingOutput":"embedding", 
            "input": {"input": ["DATA"]}}'));
end;
/
pause
host start sample_pics.jpg
pause
clear screen
create table pics ( pk int, n varchar2(20), b blob);
insert into pics values (1, 'Connor', to_blob(bfilename('JSONDOCS','connor.jpg')));
insert into pics values (2, 'Dog at Beach', to_blob(bfilename('JSONDOCS','dog_beach.jpg')));
insert into pics values (3, 'Dog at Beach 2', to_blob(bfilename('JSONDOCS','dog_beach2.jpg')));
insert into pics values (4, 'Dog on Couch', to_blob(bfilename('JSONDOCS','dog_couch.jpg')));
insert into pics values (5, 'Dog on Couch 2', to_blob(bfilename('JSONDOCS','dog_couch2.jpg')));
insert into pics values (6, 'Birds', to_blob(bfilename('JSONDOCS','birds.jpg')));
pause
commit;
clear screen
create table pics_vec as
select pk,n,vector_embedding(IMG_MODEL using b as data) as vec
from pics;
pause
select a.pk, b.pk, a.n, b.n, vector_distance(a.vec, b.vec , cosine)  dist
from pics_vec a, pics_vec b
where a.pk < b.pk
order by 5;

pause Done


