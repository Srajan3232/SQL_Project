select * from olympics_history
select * from olympics_history_noc_regions 
--Q1- How many olympics games have been held?
select count(distinct games) total_olympic_games
from olympics_history

--Q2- List down all Olympics games held so far?
select distinct oh.year,oh.season,oh.city
from olympics_history oh
order by year;

--Q3- Mention the total no of nations who participated in each olympics game?
select games, count(games) as total_countries
from (select games, nr.region
      from olympics_history oh
      join olympics_history_noc_regions nr ON nr.noc = oh.noc
      group by games, nr.region) all_countries
group by games
order by games;
	
--Q4- Which year saw the highest and lowest no of countries participating in olympics?
with all_countries as
              (select games, nr.region
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
      tot_countries as
              (select games, count(1) as total_countries
              from all_countries
              group by games)
      select distinct
      concat(first_value(games) over(order by total_countries)--here by using first_value we get the lowest games name in each row as we are order by asc
      , ' - '
      , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
      concat(first_value(games) over(order by total_countries desc)--here by using first_value we get the highest games name in each row as we are order by desc
      , ' - '
      , first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
      from tot_countries
      order by 1;

--Q5- Which nation has participated in all of the olympic game?
    with tot_games as
              (select count(distinct games) as total_games
              from olympics_history),
          countries as
              (select games, nr.region as country
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          countries_participated as
              (select country, count(1) as total_participated_games
              from countries
              group by country)
      select cp.*
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by 1;

--Q6- Identify the sport which was played in all summer olympics?
with t1 as 
      (select count(distinct(games)) total_games
	   from olympics_history
	   where season='Summer'),
	 t2 as
	 (select sport, count(distinct(games)) as no_of_games
      from olympics_history
	  where season='Summer'
      group by sport)
SELECT *
FROM t2
JOIN t1 ON t1.total_games = t2.no_of_games

--Q7- Which Sports were just played only once in the olympics?
with t1 as
     (select distinct games, sport
      from olympics_history),
     t2 as
     (select sport, count(1) as no_of_games
      from t1
      group by sport
      having count(1)=1)
select t2.*, t1.games
from t2
join t1 on t1.sport = t2.sport
order by sport  

--Q8- Fetch the total no of sports played in each olympic games?
with t1 as
      	(select distinct games, sport
      	from olympics_history),
        t2 as
      	(select games, count(1) as no_of_sports
      	from t1
      	group by games)
      select * from t2
      order by no_of_sports desc;
	  
--Q9-  Fetch oldest athletes to win a gold medal?
with t1 as 
     (select name,sex,age,height,weight,team,noc,games,year,season,city,sport,event,medal
	  from olympics_history
	  where medal='Gold' and age<>'NA'
	  group by name,sex,age,height,weight,team,noc,games,year,season,city,sport,event,medal
	  order by age desc,name desc)
	  select *
	  from T1
	  LIMIT 2

--Q10- Find the Ratio of male and female athletes participated in all olympic games?
WITH t1 AS (
  SELECT DISTINCT games, sex, COUNT(sex) AS male
  FROM olympics_history
  WHERE sex = 'M'
  GROUP BY games, sex
),
t2 AS (
  SELECT DISTINCT games, sex, COUNT(sex) AS female
  FROM olympics_history
  WHERE sex = 'F'
  GROUP BY games, sex
),
male AS (
  SELECT SUM(t1.male) AS male_total
  FROM t1
),
female AS (
  SELECT SUM(t2.female) AS female_total
  FROM t2
)
SELECT 
       ROUND(male.male_total::NUMERIC / female.female_total::NUMERIC, 2) AS male_to_female_ratio
FROM male, female;

--Q-11 Fetch the top 5 athletes who have won the most gold medals?
with Rank_data as
(Select name,team,count(medal) Total_medals,dense_rank() over (order by count(medal) desc) as rank
from olympics_history
where medal='Gold'
group by name,team
order by count(medal) desc)
select name,team,Total_medals
from Rank_data
where rank<=5

--Q-12- Fetch the top 5 athletes who have won the most medals?
with Rank_data as
(Select name,team,count(medal) Total_medals,dense_rank() over (order by count(medal) desc) as rank
from olympics_history
where medal<>'NA'
group by name,team
order by count(medal) desc)
select name,team,Total_medals
from Rank_data
where rank<=5






	  




 
																																																												 
																																																												  

