-- Selecting specific columns instead of using SELECT *
-- Purpose: This query retrieves specific columns from the covidDeath table, filtering out records where continent is null, and orders the results by location and date.
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..covidDeath
WHERE continent IS NOT NULL
ORDER BY location, date;

-- Calculating death percentage avoiding division by zero error
-- Purpose: This query calculates the death percentage for each location based on total cases and total deaths, avoiding division by zero errors.
SELECT
    location,
    date,
    CAST(total_cases AS int) AS total_cases,
    CAST(total_deaths AS int) AS total_deaths,
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE CAST(total_deaths AS decimal(10,2)) / NULLIF(total_cases, 0) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..covidDeath
WHERE continent IS NOT NULL
ORDER BY location, date;

-- Using parameters instead of hardcoding country names
-- Purpose: This query calculates the percentage of population infected for a specific country (parameterized) based on total cases and population.
DECLARE @country NVARCHAR(100) = 'Nigeria';
SELECT
    location,
    date,
    CAST(total_cases AS int) AS total_cases,
    CAST(population AS float) AS population,
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE CAST(total_cases AS decimal(10,2)) / NULLIF(population, 0) * 100
    END AS PercentofPopulationInfected
FROM 
    PortfolioProject..covidDeath
WHERE location LIKE '%' + @country + '%' AND continent IS NOT NULL
ORDER BY location, date;

-- Using a more specific data type for population column
-- Purpose: This section creates a temporary table to store data related to vaccination percentages, with a more appropriate data type for the population column.
CREATE TABLE #PercentPopulationVaccinated (
    Continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population BIGINT,
    new_vaccination NUMERIC,
    RollingPeopleVaccinated NUMERIC
);

-- Adding error handling for division by zero
-- Purpose: This query populates the temporary table with vaccination data, adding error handling to avoid division by zero errors.
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS decimal(18,2))) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..covidDeath dea
JOIN PortfolioProject..CovidVaccination vac ON dea.location = vac.location
                                             AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Using views for better organization
-- Purpose: This section creates a view to simplify querying for vaccination data.
CREATE VIEW dbo.PercentPopulationVaccinated
AS
SELECT dea.continent,
       dea.location,
       dea.date,
       dea.population,
       vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations AS decimal(18,2))) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..covidDeath dea
JOIN PortfolioProject..CovidVaccination vac ON dea.location = vac.location
                                             AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Selecting from the view
-- Purpose: This query selects data from the view PercentPopulationVaccinated.
SELECT * FROM dbo.PercentPopulationVaccinated;


-- View 1: Crossmatch columns used in the first SELECT statement
CREATE VIEW dbo.View1_CovidDeathColumns AS
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..covidDeath
WHERE continent IS NOT NULL;

-- View 2: Crossmatch columns used in the second SELECT statement
CREATE VIEW dbo.View2_DeathPercentage AS
SELECT
    location,
    date,
    CAST(total_cases AS int) AS total_cases,
    CAST(total_deaths AS int) AS total_deaths,
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE CAST(total_deaths AS decimal(10,2)) / NULLIF(total_cases, 0) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..covidDeath
WHERE continent IS NOT NULL;

-- View 3: Crossmatch columns used in the third SELECT statement
CREATE VIEW dbo.View3_PercentPopulationInfected AS
SELECT
    location,
    date,
    CAST(total_cases AS int) AS total_cases,
    CAST(population AS float) AS population,
    CASE 
        WHEN total_cases = 0 THEN 0
        ELSE CAST(total_cases AS decimal(10,2)) / NULLIF(population, 0) * 100
    END AS PercentofPopulationInfected
FROM 
    PortfolioProject..covidDeath
WHERE continent IS NOT NULL;

-- View 4: Crossmatch columns used in the fourth SELECT statement
CREATE VIEW dbo.View4_PercentPopulationVaccinated AS
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS decimal(18,2))) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..covidDeath dea
JOIN PortfolioProject..CovidVaccination vac ON dea.location = vac.location
                                             AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- View 5: Crossmatch columns used in the fifth SELECT statement
CREATE VIEW dbo.View5_PercentPopulationVaccinatedWithCountry AS
SELECT *,
       (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM dbo.View4_PercentPopulationVaccinated
WHERE location LIKE '%United Kingdom%';

-- View 6: Crossmatch columns used in the sixth SELECT statement
CREATE VIEW dbo.View6_PercentPopulationVaccinatedTempTable AS
SELECT *,
       (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM #PercentPopulationVaccinated
WHERE location LIKE '%United Kingdom%';

-- View 7: Crossmatch columns used in the seventh SELECT statement
CREATE VIEW dbo.View7_PercentPopulationVaccinatedView AS
SELECT *,
       (RollingPeopleVaccinated / Population) * 100 AS PercentPopulationVaccinated
FROM dbo.PercentPopulationVaccinated;

-- View 8: Crossmatch columns used in the eighth SELECT statement
CREATE VIEW dbo.View8_CovidDeathJoinCovidVaccination AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
       SUM(CAST(vac.new_vaccinations as float)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..covidDeath Dea
JOIN PortfolioProject..CovidVaccination Vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent is not null;

-- View 9: Crossmatch columns used in the ninth SELECT statement
CREATE VIEW dbo.View9_GlobalNumbers AS
SELECT
    --date,
    SUM(CAST(new_cases AS int)) AS new_cases,
    SUM(CAST(new_deaths AS int)) AS new_deaths,
    CASE 
        WHEN SUM(CAST(new_cases AS int)) = 0 THEN 0
        ELSE SUM(CAST(new_deaths AS float)) / SUM(CAST(new_cases AS float)) * 100
    END AS DeathPercentage
FROM 
    PortfolioProject..covidDeath
WHERE 
    continent IS NOT NULL;

