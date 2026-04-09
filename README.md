# bird-species-analysis
An end-to-end environmental data science project analyzing bird biodiversity across US National Parks. Features Python ETL, SQL exploratory analysis, and Power BI dashboards to support conservation strategies.

# Bird Species Observation & Conservation Analysis

## Project Overview
This project analyzes 17,077 bird observations across 11 National Park units to understand biodiversity trends during the 2018 breeding season. By integrating habitat data with environmental variables, the analysis identifies key conservation priorities and optimal monitoring windows for land managers.

## The Data Pipeline
1.  **ETL (Python/Pandas):** Cleaned and merged multi-sheet Excel data from Forest and Grassland habitats, handling inconsistent naming and null values.
2.  **Exploratory Data Analysis (SQL):** Conducted temporal, spatial, and species-level analysis using MySQL.
3.  **Visualization (Power BI):** Created interactive dashboards to track at-risk species and the impact of environmental disturbances.

## Key Insights
* **Biodiversity Hotspots:** Monocacy National Battlefield emerged as the most species-rich unit.
* **Conservation Need:** 23.3% of observations involved species under the Regional Stewardship Priority.
* **Optimal Monitoring:** Data suggests June mornings (5:00 AM – 8:00 AM) are the peak window for acoustic and visual surveys.
* **Disturbance Impact:** Higher levels of environmental disturbance showed a direct correlation with decreased species richness.

## Dashboard Highlights
### Conservation & Priority Analysis
![Conservation Analysis](./images/Conservation%20Analysis.png)

### Environmental Impact on Sightings
![Environmental Analysis](./images/Environmental%20Analysis.png)

## Repository Contents
* **[Preprocessing Notebook](./scripts/bird_species_preprocessing.ipynb):** Python script for data cleaning and transformation.
* **[SQL Analysis](./scripts/bird_species_observation_analysis.sql):** Queries for species distribution and temporal trends.
* **[Detailed Report](./docs/bird_species_observation_analysis_project_document.pdf):** Full methodology and strategic recommendations for ecologists.

---
**Author:** Madhuresh Raj Selvaraj
