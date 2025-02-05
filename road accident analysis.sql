use Accident_Summary_DB
select * from accidents
-- 1. Total Number Of casualƟes of this year
select sum([number_of_casualties]) as current_year_casualties from [dbo].[accidents]
where Year(accident_date)='2022';

-- 2. Total Number of accident of this year
select count(distinct(accident_index)) as Current_year_accident from  [dbo].[accidents]
where year(accident_date)='2022';

-- 3. Current Year fatal Casualtes
select sum([number_of_casualties]) as Current_year_Fatal from [dbo].[accidents]
where year(accident_date)='2022' and accident_severity='fatal';

--4. Current Year Serious casualƟes
select sum(number_of_casualties) as Current_year_Serious from [dbo].[accidents]
where year(accident_date)='2022' and accident_severity='Serious';

--5. Current Year Slight CasualƟes
select sum(number_of_casualties) as Current_year_slight from [dbo].[accidents]
where year(accident_date)='2022' and accident_severity='slight';
-- 6.Group the Vehicle type with their number of accident by them
SELECT
  vehicle_category,
  SUM(number_of_casualties) AS Current_year_casualties
FROM (
  SELECT 
    CASE
      WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'cars'
      WHEN vehicle_type = 'Agricultural Vehicle' THEN 'Agricultural'
      WHEN vehicle_type IN ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc') THEN 'bikes'
      WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'buses'
      WHEN vehicle_type IN ('Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under', 'Goods 7.5 tonnes mgw and over') THEN 'Vans'
      ELSE 'Others'
    END AS vehicle_category,
    number_of_casualties
  FROM 
    [dbo].[accidents]
  WHERE 
    YEAR(accident_date) = 2022
) AS derived_table
GROUP BY
  vehicle_category;


-- 7. Current Year casualƟes month trend
select format(accident_date,'yyyy') as Year,format(accident_date,'MMMM') as Month_name, sum(number_of_casualties) as CY_casualƟes
from [dbo].[accidents]
Group by format(accident_date,'yyyy'),format(accident_date,'MMMM');

-- 8. Previous Year casualƟes month trend
select Monthname(accident_date) as Month_name, sum(Number_of_casualƟes) as Previous_casualƟes
from road_accident
where year(accident_date)='2021'
Group by Month_name;

-- 9. CasualƟes in different Different Type Road Types
select road_type, sum(number_of_casualties) from [dbo].[accidents]
where year(accident_date)='2022'
Group by road_type
-- 10. CasualƟes in Rural and Urban Areas
select urban_or_rural_area ,sum(number_of_casualties) 
from [dbo].[accidents]
where year(accident_date)='2022'
group by urban_or_rural_area

-- 11. CasualƟes by lightening CondiƟon
SELECT 
  Light_condition,
  SUM(number_of_casualties) AS Total_Casualties
FROM (
  SELECT 
    CASE 
      WHEN light_conditions = 'Daylight' THEN 'Day'
      WHEN light_conditions IN ('Darkness - lights lit', 'Darkness - lighting unknown', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Night'
      ELSE 'Other'
    END AS Light_condition,
    number_of_casualties
  FROM 
    [dbo].[accidents]
  WHERE 
    YEAR(accident_date) = 2022
) AS derived_table
GROUP BY 
  Light_condition;


-- 12. Top 10 locaƟon where the highest number of casualƟes occured
select top 10 local_authority, sum(number_of_casualties) as total_casualƟes 
from  [dbo].[accidents]
where Year(accident_date)='2022'
group by local_authority
order by total_casualƟes desc


SELECT 
  CAST((current_year_casualties - last_casualties) * 100.0 / last_casualties AS FLOAT) AS Casualty_Percentage_Change
FROM 
  (SELECT SUM([number_of_casualties]) AS current_year_casualties 
   FROM [dbo].[accidents]
   WHERE YEAR(accident_date) = 2022) AS total_current_year,
  
  (SELECT SUM([number_of_casualties]) AS last_casualties 
   FROM [dbo].[accidents]
   WHERE YEAR(accident_date) = 2021) AS total_last_year;

------------------------------------------------------------------------------------------
SELECT 
  CAST((Current_year_Fatal - last_Current_year_Fatal) * 100.0 / last_Current_year_Fatal AS FLOAT) AS Fatality_Percentage_Change
FROM 
  (SELECT SUM([number_of_casualties]) AS Current_year_Fatal 
   FROM [dbo].[accidents]
   WHERE YEAR(accident_date) = 2022 AND accident_severity = 'fatal') AS total_current_year,
  
  (SELECT SUM([number_of_casualties]) AS last_Current_year_Fatal 
   FROM [dbo].[accidents]
   WHERE YEAR(accident_date) = 2021 AND accident_severity = 'fatal') AS total_last_year;
