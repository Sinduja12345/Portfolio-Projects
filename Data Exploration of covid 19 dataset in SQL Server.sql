--select data

select * from CovidDeath where location='india' 
Select Location,date,total_cases,new_cases,total_deaths,population
from CovidDeath
order by 1
--looking at totalcases vs totaldeaths

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from CovidDeath where location ='india'
order by 1


alter table covidDeath
alter column total_deaths float

--looking at totalcasesvs population


Select Location,date,total_cases,population,(total_cases/population)*100 as deathpercentage
from CovidDeath where location ='india'

--infectedpercentage

select location,population, max(total_cases)asmaxtotalcase,max((total_cases/population))*100 as infectedpercentage
from coviddeath
where location='india'
group by location,population
order by infectedpercentage desc

--showing conteries with highest deathcount per percentage

select location,date,total_deaths,max(total_deaths) as highestdeathcount
from CovidDeath
--where location='india'
group by location,date,total_deaths
order by highestdeathcount desc


select location,max(cast(total_deaths as int) )as highestdeathcount
from CovidDeath
--where location='india'
where continent is not null
group by location
order by highestdeathcount desc

--continentwise

select location,max(cast(total_deaths as int) )as highestdeathcount
from CovidDeath
--where location='india'
wh
ere continent is  null
group by location
order by highestdeathcount desc

--overall totalcase, totaldeath percentage

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int)) /sum(new_cases)  *100 as deathpercentage
from coviddeath


select sum(total_cases) as total_cases,sum(total_deaths ) as total_deaths,
sum(total_deaths) /sum(total_cases)  *100 as deathpercentage
from coviddeath
--total population vs vaccination


select cd. continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations))over (partition by cd.location order by cd.location,cd.date)as vaccinated
from CovidDeath cd
join Covidvaccination cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null and cd.location='india'and cv.new_vaccinations is not null
group by cd. continent,cd.location,cd.date,cd.population,cv.new_vaccinations
order by 2,3


---cte 
with popvsvac(continent,location,date,population,new_vaccinations,vaccinated)
as
(
select cd. continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(convert(int,cv.new_vaccinations))over (partition by cd.location order by cd.location,cd.date)as vaccinated
from CovidDeath cd
join Covidvaccination cv
on cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null and cd.location='india'and cv.new_vaccinations is not null
--group by cd. continent,cd.location,cd.date,cd.population,cv.new_vaccinations
--order by 2,3
)
select *,(vaccinated/population)*100
from popvsvac


--#temp table
drop table if exists  #percentagepapulationvaccination
create table #percentagepapulationvaccination
(
continent nvarchar(100),
location nvarchar(100),
date datetime,
population numeric,
new_vaccinations numeric,
vaccinated numeric
)
insert into #percentagepapulationvaccination
select cd. continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(convert(bigint,cv.new_vaccinations))over (partition by cd.location order by cd.location,cd.date)as vaccinated
from CovidDeath cd
join Covidvaccination cv
on cd.location=cv.location
and cd.date=cv.date
--where cd.continent is not null and cd.location='Zimbabwe'and cv.new_vaccinations is not null
--group by cd. continent,cd.location,cd.date,cd.population,cv.new_vaccinations
--order by 2,3
select *,(vaccinated/population)*100
from #percentagepapulationvaccination

---creating view for later percentagepapulationvaccination visulaizations

create view percentagepapulationvaccination as
select cd. continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
sum(convert(bigint,cv.new_vaccinations))over (partition by cd.location order by cd.location,cd.date)as vaccinated
from CovidDeath cd
join Covidvaccination cv
on cd.location=cv.location
and cd.date=cv.date
--where cd.continent is not null and cd.location='Zimbabwe'and cv.new_vaccinations is not null

