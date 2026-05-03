select * from `workspace`.`default`.`md_summary` limit 100;

----Level 1: Basic Selection & Filtering
--------------------------------------------------------------------------------------
---.	Top Records:- Write a query to view the first 10 rows of the dataset to understand the structure.

SELECT *
from `workspace`.`default`.`md_summary` limit 10;

------2.	Unique Sources: Write a query to find all distinct types of water sources available in the type_of_water_source column
Select Distinct type_of_water_source
from `workspace`.`default`.`md_summary`;


----3.	Contamination Check: Select the address, town_name, and biological levels for all records where the biological level is greater than 0.01.
SELECT 
    `address`,
    `town_name`,
    `biological` as `biological_level`0
FROM `workspace`.`default`.`md_summary`
WHERE `biological` > 0.01;

---4.	Null Search: Find all records where the results column is NULL
SELECT *
FROM `workspace`.`default`.`md_summary`
WHERE `results` IS NULL;
 ------------------------------------------------------
 -----Replace Null with 0
 SELECT 
    `address`, 
    `town_name`, 
    -- Replaces NULLs with 0 in the output
    COALESCE(`biological`, 0) AS biological,
    COALESCE(`description`, 0) AS description,
    COALESCE(`pollutant_ppm`, 0) AS pollutant_ppm,
    COALESCE(`date`, 0) AS date,
    COALESCE(`results`, 0) AS results
FROM `workspace`.`default`.`md_summary`
WHERE 
    `date` IS NULL 
    AND `description` IS NULL 
    AND `pollutant_ppm` IS NULL 
    AND `biological` IS NULL 
    AND `results` IS NULL
-----------------------------------------------------------------------------------------------------------------------
-----Level 2: Aggregations and Grouping
-------------------------------------------------------------------------------------------------------------
----5.	Province Statistics: Count how many records exist for each province_name and sort them from highest to lowest.
SELECT Count(*)  As Province_name 
FROM `workspace`.`default`.`md_summary`
GROUP by province_name
ORDER BY Province_name DESC;
------------------------------------------------------------------------------------------------------------------------------
----6.	Queue Time Analysis: Calculate the average time_in_queue for each type_of_water_source. Which source type generally has the longest wait?
SELECT type_of_water_source, avg(time_in_queue) as avg_time_in_queue
FROM `workspace`.`default`.`md_summary`
GROUP BY type_of_water_source
ORDER BY avg_time_in_queue DESC;
------------------------------------------------------------------------------------------------------------------------------------------------
------7.	Population Served: What is the total number_of_people_served across each town_name
SELECT 
    `town_name`,
    SUM(`number_of_people_served`) AS total_number_of_people_served
FROM `workspace`.`default`.`md_summary`
GROUP BY `town_name`
ORDER BY total_number_of_people_served DESC;
---------------------------------------------------------------------------------------------------------

-----8.	Day of Week Activity: Find the total visit_count for each day_of_week to see which day is the busiest

SELECT count(`visit_count`) as total_visit_count, `day_of_week`
FROM `workspace`.`default`.`md_summary`
GROUP BY `day_of_week`
ORDER BY total_visit_count DESC;
---------------------------------------------------------------------------------------------------------
-----9.)9.	Demographic Calculation: Write a query that shows the location_id and calculates the actual number of children served at that location (i.e., number_of_people_served multiplied by percent_child / 100).
SELECT `location_id`, `number_of_people_served` * `percent_child` / 100 AS `children_served`
FROM `workspace`.`default`.`md_summary`;
----------------------------------------------------------------------------------------------------------
-----10.	Peak Hour Identification: Group the data by hour_of_day and find the average visit_count. Sort the results to find the "rush hour-

select hour_of_day, avg(`visit_count`) as avg_visit_count
from `workspace`.`default`.`md_summary`
group by hour_of_day;
-------------------------------------------------------------------------------------------

-------11.	Filtering with Subqueries: Find all records in towns where the average pollutant_ppm is higher than the overall average pollutant level of the entire dataset.
SELECT *
FROM `workspace`.`default`.`md_summary`
WHERE `town_name` IN (
    SELECT `town_name`
    FROM `workspace`.`default`.`md_summary`
    GROUP BY `town_name`
    HAVING AVG(`pollutant_ppm`) > (
        SELECT AVG(`pollutant_ppm`)
        FROM `workspace`.`default`.`md_summary`
    )
);
-------------------------------------------------------------------------------------------
-----12:	High-Traffic Locations: Use a CASE statement to create a new column called Traffic_Level. If visit_count is 1, label it 'Low'; if between 2 and 5, 'Medium'; if above 5, 'High'

SELECT *,
    CASE
        WHEN `visit_count` = 1 THEN 'Low'
        WHEN `visit_count` BETWEEN 2 AND 5 THEN 'Medium'
        ELSE 'High'
    END AS Traffic_Level
FROM `workspace`.`default`.`md_summary`;
