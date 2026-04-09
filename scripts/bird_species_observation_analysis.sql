CREATE TABLE bird_cleaned_data (
    admin_unit_code TEXT,
    sub_unit_code TEXT,
    site_name TEXT,
    plot_name TEXT,
    location_type TEXT,
    year INT,
    date TEXT,
    start_time TEXT,
    end_time TEXT,
    observer TEXT,
    visit INT,
    interval_length TEXT,
    id_method TEXT,
    distance TEXT,
    flyover_observed TEXT,
    sex TEXT,
    common_name TEXT,
    scientific_name TEXT,
    acceptedtsn TEXT,
    npstaxoncode TEXT,
    aou_code TEXT,
    pif_watchlist_status TEXT,
    regional_stewardship_status TEXT,
    temperature TEXT,
    humidity TEXT,
    sky TEXT,
    wind TEXT,
    disturbance TEXT,
    initial_three_min_cnt TEXT,
    habitat TEXT,
    taxoncode text,
    previously_obs text
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/bird_cleaned_data.csv'
INTO TABLE bird_cleaned_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Temporal Analysis
# 1. Monthly Trends
select 
	year(date) as year, 
    monthname(date) as month,
count(*) as total_observations
from bird_analysis.bird_cleaned_data
group by year(date), month(date), monthname(date)
order by year(date), month(date);

# 2. Seasonal Trend across the year
select
	year(date) as year,
    case
		when month(date) in (12, 1, 2) then 'Winter'
        when month(date) in (3, 4, 5) then 'Summer'
        when month(date) in (6, 7, 8) then 'Monsoon'
        else 'Post-Monsoon'
	end as season,
	count(*) as total_observations    
from bird_analysis.bird_cleaned_data
group by year(date), season
order by year(date), season;

# 3. Biodiversity Variation by Season
select
	case
		when month(date) in (12, 1, 2) then 'Winter'
        when month(date) in (3, 4, 5) then 'Summer'
        when month(date) in (6, 7, 8) then 'Monsoon'
        else 'Post-Monsoon'
	end as season,
	count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by season
order by species_count desc;

# Observation Time Analysis
# Bird Activity By Hour
select
    hour(start_time) as hour,
    count(*) as observations
from bird_analysis.bird_cleaned_data
group by hour
order by hour;

# Best Observation Window
select 
    case 
        when hour(start_time) between 5 and 8 then 'Early Morning'
        when hour(start_time) between 9 and 12 then 'Late Morning'
        when hour(start_time) between 13 and 16 then 'Afternoon'
        else 'Evening'
    end as time_slot,
    count(*) as observations
from bird_analysis.bird_cleaned_data
group by time_slot
order by observations desc;

# . Bird Activity Type
use bird_analysis;
select id_method, count(*) as observations, round(count(*)* 100.0/(select count(*) from bird_cleaned_data), 2) as percentage
from bird_analysis.bird_cleaned_data
where id_method is not null and id_method !=''
group by id_method
order by observations desc;

# Spatial Analysis
# Observations by Location Type
use bird_analysis;
SELECT 
    location_type,
    COUNT(*) AS total_observations
FROM bird_cleaned_data
GROUP BY location_type
ORDER BY total_observations DESC;

# Species Diversity by Location
select
	location_type,
    count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by location_type
order by species_count desc;

# Top Species Per Location
select location_type, scientific_name, count(*) as observations
from bird_analysis.bird_cleaned_data
group by location_type, scientific_name
order by location_type, observations desc;

# Top Plots by Total Observations
select plot_name, count(*) as total_observations
from bird_analysis.bird_cleaned_data
group by plot_name
order by total_observations desc
limit 10;

# Biodiversity Hotspots
select plot_name, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by plot_name
order by species_count desc
limit 10;

# Best Plots Within Each Habitat
select location_type, plot_name, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by location_type, plot_name
order by species_count desc;

# Species Analysis
# Total unique Species
select count(distinct scientific_name) as total_species
from bird_analysis.bird_cleaned_data;

# Species Distribution by Location Type
select location_type, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by location_type
order by species_count desc;

# Top 10 Most Observed Species
select scientific_name, count(*) as observations
from bird_analysis.bird_cleaned_data
group by scientific_name
order by observations desc
limit 10;

# Least Observed Species
select scientific_name, count(*) as observations
from bird_analysis.bird_cleaned_data
group by scientific_name
having observations = 1
order by scientific_name;

# Common Observation Duration
select interval_length, count(*) as observations
from bird_analysis.bird_cleaned_data
group by interval_length
order by observations desc;

# Overall Sex Distribution
select sex, count(*) as count
from bird_analysis.bird_cleaned_data
group by sex;

# Sex Ratio by Species
select scientific_name,
    sum(case when sex = 'Male' then 1 else 0 end) as male_count,
    sum(case when sex = 'Female' then 1 else 0 end) as female_count
from bird_analysis.bird_cleaned_data
group  by scientific_name
order by male_count + female_count desc;

# Species with Male Bias
select scientific_name,
    sum(case when sex = 'Male' then 1 else 0 end) as male_count,
    sum(case when sex = 'Female' then 1 else 0 end) as female_count
from bird_analysis.bird_cleaned_data
group by scientific_name
having male_count > female_count
order by male_count desc;

# Environmental Conditions
# Temperature vs Bird Observations
select round(temperature, 0) as temp_range, count(*) as observations
from bird_analysis.bird_cleaned_data
where temperature is not null
group by temp_range
order by temp_range;

# Humidity Impact
select round(humidity, 0) as humidity_range, count(*) as observations
from bird_analysis.bird_cleaned_data
where humidity is not null
group  by humidity_range
order by humidity_range;

# Sky Condition Analysis
select sky, count(*) as observations
from bird_analysis.bird_cleaned_data
group by sky
order by observations desc;

# Wind Impact
select wind, count(*) as observations
from bird_analysis.bird_cleaned_data
group by wind
order by observations desc;

# Combined Weather Impact
select sky, wind, count(*) as observations
from bird_analysis.bird_cleaned_data
group by sky, wind
order by observations desc;

# Disturbance vs Observations
select disturbance, count(*) as observations
from bird_analysis.bird_cleaned_data
group by disturbance
order by observations desc;

# Disturbance vs Species Diversity
select disturbance, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by disturbance
order by species_count desc;

# Distance and Behavior Analysis
# Overall Distance Distribution
select distance, count(*) as observations
from bird_analysis.bird_cleaned_data
where distance is not null and distance != ''
group by distance
order by observations desc;

# Distance vs Species
select distance, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
where distance is not null and distance != ''
group by distance
order by species_count desc;

# Species Observed at Specific Distances
select distance, scientific_name, count(*) as observations
from bird_analysis.bird_cleaned_data
where distance is not null and distance != ''
group by distance, scientific_name
order by distance, observations desc;

# Flyover Distribution
select flyover_observed, count(*) as observations
from bird_analysis.bird_cleaned_data
group by flyover_observed;

# Flyover Percentage
select flyover_observed, count(*) as observations, round(count(*) * 100.0 / (select count(*) from bird_analysis.bird_cleaned_data), 2) as percentage
from bird_analysis.bird_cleaned_data
group by flyover_observed;

# Flyover vs Species Diversity
select flyover_observed, count(distinct scientific_name) as species_count
from bird_cleaned_data
group by flyover_observed;

# Observer Bias Analysis
# Observations per Observer
select observer, count(*) as total_observations
from bird_analysis.bird_cleaned_data
where observer is not null and observer != ''
group by observer
order by total_observations desc;

# Unique Species per Observer
select observer, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
where observer is not null and observer != ''
group by observer
order by species_count desc;

# Avg Observations per Visit
select observer, count(*) / count(distinct visit) as avg_obs_per_visit
from bird_analysis.bird_cleaned_data
where observer is not null and observer != ''
group by observer
order by avg_obs_per_visit desc;

# Observer vs Top Species
select observer, scientific_name, count(*) as observations
from bird_analysis.bird_cleaned_data
group by observer, scientific_name
order by observer, observations desc;

# Observations per Visit
select visit, count(*) as total_observations
from bird_analysis.bird_cleaned_data
group by visit
order by visit;

# Species Diversity per Visit
select visit, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by visit
order by visit;

# Avg Observations per Visit
select avg(obs_count) as avg_observations_per_visit
from (
    select visit, count(*) as obs_count
    from bird_analysis.bird_cleaned_data
    group by visit
) as visit_stats;

# Visit vs Habitat
select visit, habitat, count(*) as observations
from bird_analysis.bird_cleaned_data
group by visit, habitat
order by visit;

# Conservation Analysis
# Count At-Risk vs Not At-Risk
select pif_watchlist_status, count(*) as observations
from bird_analysis.bird_cleaned_data
group by pif_watchlist_status
order by observations desc;

# Unique At-Risk Species Count
select pif_watchlist_status, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by pif_watchlist_status;

# Top At-Risk Species
select scientific_name, count(*) as observations
from bird_analysis.bird_cleaned_data
where pif_watchlist_status is not null
  and pif_watchlist_status != ''
group by scientific_name
order by observations desc
limit 10;

# Regional Stewardship Status
select regional_stewardship_status, count(*) as observations
from bird_analysis.bird_cleaned_data
group by regional_stewardship_status
order by observations desc;

# Combined Conservation Priority
select pif_watchlist_status, regional_stewardship_status, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by pif_watchlist_status, regional_stewardship_status
order by species_count desc;

# Distribution of AOU Codes
select aou_code, count(*) as observations
from bird_analysis.bird_cleaned_data
group by aou_code
order by observations desc
limit 10;

# Unique Species per AOU Code
select aou_code, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
group by aou_code
order by species_count desc;

# AOU Code vs Watchlist
select aou_code, count(distinct scientific_name) as species_count
from bird_analysis.bird_cleaned_data
where pif_watchlist_status is not null
  and pif_watchlist_status != ''
group by aou_code
order by species_count desc;

# At-Risk Species by Habitat
select habitat, count(distinct scientific_name) as at_risk_species
from bird_analysis.bird_cleaned_data
where pif_watchlist_status is not null 
  and pif_watchlist_status != ''
group by habitat;