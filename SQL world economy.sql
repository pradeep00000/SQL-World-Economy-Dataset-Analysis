create schema world;
select * from worldbank;

#1. List all countries and their respective regions.
select `Country Name` , Region
from worldbank;

#2. Find the average GDP per capita for each income group.
select IncomeGroup , avg(`GDP per capita (USD)`)
from worldbank
group by IncomeGroup;

#3. Retrieve all records for a specific year, e.g., 2018.
select * from worldbank
where Year = 2018;

#4. List the top 5 countries by population density in 2018.
select `Country Name` ,
 sum(`Population density (people per sq. km of land area)`)
 as Population_Density from worldbank
 where Year = 2018
group by `Country Name`
order by Population_Density desc
limit 5;

#5. Count the number of countries in each region.
select Region , count(distinct `Country Name`)
from worldbank
group by Region;

#6. Identify countries with an unemployment 
#   rate greater than 10% in any year.
select `Country Name` , Year , 
`Unemployment (% of total labor force) (modeled ILO estimate)` 
from worldbank 
where Year = 2018 and 
`Unemployment (% of total labor force) (modeled ILO estimate)` > 10;

#7. Compare GDP per capita between high-income and 
#   low-income countries for the year 2018.
select `IncomeGroup`, avg(`GDP per capita (USD)`) as Average_GDP_Per_Capita
from WorldBank
where Year = 2018 and IncomeGroup in ('High income', 'Low income')
group by IncomeGroup;

#8.  Find the top 3 countries with the highest internet usage percentage in 2018.
select `Country Name`, `Individuals using the Internet (% of population)`
from WorldBank
where `Year` = 2018
order by `Individuals using the Internet (% of population)` desc
limit 3;

#9. show the trend of life expectancy for a specific country (e.g., india).
select `Year`, `life expectancy at birth (years)`
from worldbank
where `country name` = 'india'
order by `Year`;

#10. list countries with missing gdp data.
select distinct `Country Name`
from worldbank
where `gdp (usd)` is null;

#12. identify regions with the highest average
#    birth rate over the years.
select Region, avg(`birth rate, crude (per 1,000 people)`)
 as average_birth_rate from worldbank
group by Region
order by average_birth_rate desc
limit 1;

#13. find countries where the life expectancy 
#    is below the global average for 2018.
with global_average as (
    select avg(`life expectancy at birth (years)`)
    as avg_life_expectancy from worldbank
    where `Year` = 2018
)
select `Country Name`, `life expectancy at birth (years)`
from worldbank, global_average
where `Year` = 2018 and `life expectancy at birth (years)`
 < avg_life_expectancy;

#14. rank countries by gdp per capita growth rate 
#    between 2015 and 2018.
with gdp_growth as (
    select `Country Name`, 
           (max(`gdp per capita (usd)`) -
min(`gdp per capita (usd)`)) / min(`gdp per capita (usd)`)
* 100 as growth_rate
    from worldbank
    where `Year` between 2015 and 2018
    group by `Country Name`
)
select `Country Name`, growth_rate
from gdp_growth
order by growth_rate desc;

#15. identify the top 5 regions with the lowest 
#    unemployment rates in 2018.
select Region, avg(`Unemployment (% of total 
labor force) (modeled ILO estimate)`) as avg_unemployment
from worldbank
where `Year` = 2018
group by Region
order by avg_unemployment asc
limit 5;

#16. find countries with consistent internet 
#    usage growth from 2015 to 2018.
with growth_trend as (
    select `Country Name`, `Year`, `Individuals using the internet 
    (% of population)`,
           lag(`Individuals using the internet (% of population)`) 
over (partition by "country name" order by "year") as prev_internet_usage
    from worldbank
    where `Year` between 2015 and 2018
)
select `Country Name`
from growth_trend
where `Individuals using the internet (% of population)` > prev_internet_usage
group by `Country Name`
having count(`Tear`) = 3;

#17. calculate the average death rate for low-income countries over time.
select `Year`, avg(`Death rate, crude (per 1,000 people)`) as avg_death_rate
from worldbank
where incomegroup = 'low income'
group by `Year`
order by `Year`;

#18. compare life expectancy trends between
#    two regions (e.g., sub-saharan africa and europe).
select Region, `Year`, 
avg(`Life expectancy at birth (years)`)
from worldbank
where Region in (`Sub-Saharan Africa`, `Europe & Central Asia`)
group by Region, `Year`
order by `Year`;

#19. find the global percentage of internet users in 2018.
select sum(`Individuals using the Internet (% of population)`)
/ count(*) as global_internet_percentage
from worldbank
where `Year`= 2018;

#20. identify the top 3 countries with the largest 
#    gaps between birth and death rates in 2018.
select `Country Name`, 
       (`Birth rate, crude (per 1,000 people)`
- `Death rate, crude (per 1,000 people)`) as rate_difference
from worldbank
where `Year`= 2018
order by rate_difference desc
limit 3;
