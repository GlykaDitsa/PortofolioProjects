Select *
From [project covid deaths]..['COVIDDEATHS']
where continent is not null
order by 3,4


Select distinct (location),date,total_cases,new_cases,total_deaths,population
From [project covid deaths]..['COVIDDEATHS']
order by 1,2



Select location,date, total_cases,total_deaths, (CAST(total_deaths as float) /CAST(total_cases as float))*100 as deathprese
From [project covid deaths]..['COVIDDEATHS']
where location like '%United States%'
order by 1,2

Select location,date, total_cases,population, (CAST(total_cases as float) /CAST(population as float))*100 as Precentpopulation
From [project covid deaths]..['COVIDDEATHS']
where location like '%United States%'
order by 1,2


Select location,population, MAX(total_cases) as Highestinfection , Max(CAST(total_cases as float) /CAST(population as float))*100 as PrecentpopulationInfected
From [project covid deaths]..['COVIDDEATHS']
Group by location, population
order by PrecentpopulationInfected desc


Select continent , MAX(total_deaths) as Totaldeathcount 
From [project covid deaths]..['COVIDDEATHS']
where continent is not null
Group by continent
order by Totaldeathcount desc


Select  SUM(CAST(new_cases AS FLOAT)) as total_cases,SUM(CAST(new_deaths AS FLOAT)) as total_deaths, SUM(CAST(new_deaths as float ))/SUM(CAST(new_cases as float))*100 as DeathPercentage
From  [project covid deaths]..['COVIDDEATHS']
where continent is not null
order by 1,2

select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location,
 dea.date) as rollingpeoplevaccinated
from [project covid deaths]..['COVIDDEATHS'] dea
Join [project covid deaths]..['COVIDVACCINATIONS'] vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null;



with popvsvac(continent,location,date,population,new_vaccinations, rollingpeoplevaccinated)
as
(select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location,
 dea.date) as rollingpeoplevaccinated
from [project covid deaths]..['COVIDDEATHS'] dea
Join [project covid deaths]..['COVIDVACCINATIONS']	vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
)

select * , (rollingpeoplevaccinated/population)*100
from popvsvac

drop table if exists #percentpopulationvaccinated
create Table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)



insert into #percentpopulationvaccinated
select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location,
 dea.date) as rollingpeoplevaccinated
from [project covid deaths]..['COVIDDEATHS'] dea
Join [project covid deaths]..['COVIDVACCINATIONS']	vac
	on dea.location=vac.location
	and dea.date=vac.date


select*, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated;


create view percentpopulationvaccinated as
select dea.continent,dea.location, dea.date, dea.population,vac.new_vaccinations,
 SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.location order by dea.location,
 dea.date) as rollingpeoplevaccinated
from [project covid deaths]..['COVIDDEATHS'] dea
Join [project covid deaths]..['COVIDVACCINATIONS']	vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
go

select * 
from percentpopulationvaccinated

