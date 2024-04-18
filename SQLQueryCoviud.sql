select * 
from PortfolioProject..covidDeath
WHERE continent is not null
order by 3,4


--select * 
--from PortfolioProject..covidVaccination
--order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..covidDeath
WHERE continent is not null
order by 1,2

--we are looking at total cases vs total deaths
--shows the likelihood of dying if one contract covid in his country

SELECT
    location,
    date,
    CAST(total_cases AS int) total_cases,
    CAST(total_deaths AS int) total_deaths,
    CASE 
        WHEN total_cases = 0 THEN 0 -- Avoid division by zero
        ELSE CAST(total_deaths AS float) / CAST(total_cases AS float) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..covidDeath
	WHERE continent is not null
ORDER BY 
    location, date;

--Looking at the total cases vs the population

SELECT
    location,
    date,
    CAST(total_cases AS int) total_cases,
    CAST(total_deaths AS int) total_deaths,
    CASE 
        WHEN total_cases = 0 THEN 0 -- Avoid division by zero
        ELSE CAST(total_deaths AS float) / CAST(total_cases AS float) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..covidDeath
WHERE location like 'Nigeria' and continent is not null
ORDER BY 
    location, date;





SELECT
    location,
    date,
    CAST(total_cases AS int) total_cases,
    CAST(population AS float) population,
    CASE 
        WHEN total_cases = 0 THEN 0 -- Avoid division by zero
        ELSE CAST(total_cases AS float) / CAST(population AS float) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..covidDeath
	WHERE continent is not null
ORDER BY 
    location, date;



SELECT
    location,
    date,
    CAST(total_cases AS int) total_cases,
    CAST(population AS float) population,
    CASE 
        WHEN total_cases = 0 THEN 0 -- Avoid division by zero
        ELSE CAST(total_cases AS float) / CAST(population AS float) * 100
    END AS PercentofPopulationInfected
FROM 
    PortfolioProject..covidDeath
	WHERE location like '%united%kingdom%' and continent is not null
ORDER BY 
    location, date;



--Countries with the highest infection rate compared to population rate
SELECT
    location,
    MAX(total_cases) AS HighestInfectionCount,
    CAST(MAX(population) AS float) AS population,
    CASE 
        WHEN MAX(total_cases) = 0 THEN 0 -- Avoid division by zero
        ELSE CAST(MAX(total_cases) AS float) / CAST(MAX(population) AS float) * 100
    END AS PercentofPopulationInfected
FROM 
    PortfolioProject..covidDeath
	WHERE continent is not null
GROUP BY 
    location, population
ORDER BY 
    PercentofPopulationInfected desc;




-- showing the countries with the highest death count per population 

SELECT
    location,
    MAX(CAST (total_deaths as int)) AS TotaldeathCount
    
FROM 
    PortfolioProject..covidDeath
	WHERE continent is not null
GROUP BY 
    location
ORDER BY 
    TotaldeathCount desc;



	--Breakdown by coontinent

SELECT
    location,
    MAX(CAST (total_deaths as int)) AS TotaldeathCount
    
FROM 
    PortfolioProject..covidDeath
	WHERE continent is null
GROUP BY 
    location
ORDER BY 
    TotaldeathCount desc;

--Showing the continent with the highest death count


SELECT
    continent,
    MAX(CAST (total_deaths as int)) AS TotaldeathCount
    
FROM 
    PortfolioProject..covidDeath
	WHERE continent is not null
GROUP BY 
    continent

ORDER BY 
    TotaldeathCount desc;


--Global Numbers 
SELECT
    --date,
    SUM(CAST(new_cases AS int)) AS new_cases,
    SUM(CAST(new_deaths AS int)) AS new_deaths,
    CASE 
        WHEN SUM(CAST(new_cases AS int)) = 0 THEN 0 -- Avoid division by zero
        ELSE SUM(CAST(new_deaths AS float)) / SUM(CAST(new_cases AS float)) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..covidDeath
WHERE 
    continent IS NOT NULL
--GROUP BY 
--    date
ORDER BY 
    1,2;



	-- Looking at total population vs vaccination 
select * 
from PortfolioProject..covidDeath Dea
join PortfolioProject..CovidVaccination Vac
	ON dea.location = vac.location
	and dea.date = vac.date



select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeath Dea
join PortfolioProject..CovidVaccination Vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2,3




--use CTE

WITH POPvsVAC(COntinent, location, date, Population, new_vaccination, RollinPeopleVaccinated)
AS
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..covidDeath Dea
join PortfolioProject..CovidVaccination Vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
 )

 select *, (RollinPeopleVaccinated/Population) * 100 
 from POPvsVAC
where location like '%United%Kingdom%'



--Using temp table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated (
    Continent nvarchar(255),
    location nvarchar(255),
    date datetime,
    population numeric,
    new_vaccination numeric,
    RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..covidDeath dea
JOIN PortfolioProject..CovidVaccination vac ON dea.location = vac.location
                                             AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL

SELECT *,
       (RollingPeopleVaccinated / Population) * 100
FROM #PercentPopulationVaccinated
WHERE location LIKE '%United Kingdom%'



CREATE VIEW PercentPopulationVaccinated
AS
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS float)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..covidDeath dea
JOIN PortfolioProject..CovidVaccination vac ON dea.location = vac.location
                                             AND dea.date = vac.date
WHERE dea.continent IS NOT NULL