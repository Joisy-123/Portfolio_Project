Select *
From portfolio_project..CovidDeaths$
where continent is not null
Order by 3,4

Select *
From portfolio_project..CovidVaccinations$
Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From portfolio_project..CovidDeaths$
where continent is not null
Order by 1,2

-- Total Cases VS. Total Deaths
--This shows the likelihood of dying if you contract covid in Nigeria

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
From portfolio_project..CovidDeaths$
where location like 'Nigeria'
Order by 1,2


-- Total Cases VS. Population
--This shows what percentage of population got covid

Select location, date, total_cases, population, (total_cases/population)*100 as percent_of_population_infected
From portfolio_project..CovidDeaths$
where location like 'Nigeria'
Order by 1,2

--Looking at Countries with Highest infection rate compared to population

Select location, population, MAX(total_cases) as highest_infection_count, MAX(total_cases/population)*100 as percent_of_population_infected
From portfolio_project..CovidDeaths$
where continent is not null
Group by location, population
Order by 1,2

--Countries with highest death counts per population

Select location, MAX(cast(total_deaths as int)) as total_death_count
From portfolio_project..CovidDeaths$
where continent is not null
Group by location
Order by total_death_count desc

Select continent, MAX(cast(total_deaths as int)) as total_death_count
From portfolio_project..CovidDeaths$
where continent is not null
Group by continent
Order by total_death_count desc

--Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) as total_death_count
From portfolio_project..CovidDeaths$
where continent is not null
Group by continent
Order by total_death_count desc

--GLOBAL NUMBERS

Select date, SUM(new_cases)as total_new_cases, SUM(cast(new_deaths as int))as total_new_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
From portfolio_project..CovidDeaths$
where continent is not null
Group by date
Order by 1,2

Select SUM(new_cases)as total_new_cases, SUM(cast(new_deaths as int))as total_new_deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as death_percentage
From portfolio_project..CovidDeaths$
where continent is not null
--Group by date
Order by 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From portfolio_project..CovidDeaths$ dea
join portfolio_project..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location) as Rolling_People_Vaccinated
From portfolio_project..CovidDeaths$ dea
join portfolio_project..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Order by 2,3

--CTE

With PopvsVac (Continent, Location, Date, Population,new_vaccinations, Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From portfolio_project..CovidDeaths$ dea
join portfolio_project..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
SELECT *, (Rolling_People_Vaccinated/population)*100
from PopvsVac


-- Temp Tables

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From portfolio_project..CovidDeaths$ dea
join portfolio_project..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

SELECT *, (Rolling_People_Vaccinated/population)*100
from #PercentPopulationVaccinated


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From portfolio_project..CovidDeaths$ dea
join portfolio_project..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--Order by 2,3

Select *, ( Rolling_People_Vaccinated/population)*100
From #PercentPopulationVaccinated

-- Creating view to store data

Create view percentpopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as Rolling_People_Vaccinated
From portfolio_project..CovidDeaths$ dea
join portfolio_project..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--Order by 2,3

select*
From percentpopulationVaccinated