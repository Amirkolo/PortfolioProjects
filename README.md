# COVID-19 Data Analysis SQL Views

This repository contains SQL views created for analyzing COVID-19 data from the PortfolioProject database. The views are designed to provide insights into various aspects of the pandemic, such as cases, deaths, vaccinations, and population statistics.

## Views Overview

1. View1_CovidDeathColumns: Combines columns related to COVID-19 cases and deaths from the covidDeath table.
2. View2_DeathPercentage: Calculates the death percentage for each location based on total cases and total deaths.
3. View3_PercentPopulationInfected: Calculates the percentage of population infected for each location.
4. View4_PercentPopulationVaccinated: Combines columns related to COVID-19 vaccinations from the CovidVaccination table.
5. View5_PercentPopulationVaccinatedWithCountry: Calculates the percentage of population vaccinated for a specific country.
6. View6_PercentPopulationVaccinatedTempTable: Temporary table view for calculating the percentage of population vaccinated.
7. View7_PercentPopulationVaccinatedView: View for calculating the percentage of population vaccinated.
8. View8_CovidDeathJoinCovidVaccination: Combines columns related to COVID-19 cases, deaths, and vaccinations.
9. View9_GlobalNumbers: Calculates global COVID-19 statistics, including new cases, new deaths, and death percentage.
10. View10_CovidDeathAndDeathPercentage: Combines columns related to COVID-19 cases, deaths, and death percentage.
11. View11_PercentPopulationAndVaccination: Combines columns related to population statistics and vaccinations.
12. View12_TwoPercentPopulationVaccinated: Combines columns related to population vaccination percentages for a specific country.
13. View13_PercentPopulationAndCovidVaccination: Combines columns related to population statistics and COVID-19 cases/vaccinations.
14. View14_GlobalNumbersAndRandom: Combines global COVID-19 statistics with data from another view.

## Usage

You can query these views to analyze different aspects of COVID-19 data, such as cases, deaths, vaccinations, and population statistics. Each view provides a different perspective on the data, allowing for comprehensive analysis and insights.

Feel free to customize the queries based on your specific analysis requirements and use cases.

## Requirements

- Access to the PortfolioProject database
- SQL Server Management Studio or another SQL client to run queries
