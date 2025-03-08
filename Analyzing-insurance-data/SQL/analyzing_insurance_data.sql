-- Exploratory Data Analysis

-- Exploring Categorical Data

-- Grouping data by sex and calculating count and charges amount
SELECT 
    sex,
    COUNT(*) AS count, -- Counting the number of records for each group
    -- Summing the 'charges' for each group, dividing by 1000 to convert to thousands,
    -- rounding to 1 decimal place, and appending 'k' to represent thousands
    CONCAT(ROUND(SUM(charges)/1000, 1), "k") AS charges_amount 
FROM insurance
GROUP BY sex;
    
    -- Grouping data by smoker status and calculating the number of records and charges
SELECT 
    smoker,
    -- Counting the number of records per smoker group
    COUNT(*) AS count, 
    -- Summing 'charges', converting to thousands, rounding, and adding 'k'
    CONCAT(ROUND(SUM(charges)/1000, 1), "k") AS charges_amount
    FROM insurance
GROUP BY smoker;

-- Grouping data by region and calculating the number of records and charges
SELECT 
    region,
    -- Counting the number of records per region
    COUNT(*) AS count, 
    -- Summing 'charges', converting to thousands, rounding, and adding 'k'
    CONCAT(ROUND(SUM(charges)/1000, 1), "k") AS charges_amount 
FROM insurance
GROUP BY region;

-- Exploring numeric data

-- Calculating BMI, age and charges statistics grouped by sex, smoker and region) (min, max, average, and standard deviation)

SELECT sex, min(bmi), max(bmi), round(avg(bmi), 2) AS avg, round(stddev_pop(bmi), 2) AS stddev
FROM insurance
GROUP BY sex;

SELECT smoker, min(bmi), max(bmi), round(avg(bmi), 2) AS avg, round(stddev_pop(bmi), 2) AS stddev
FROM insurance
GROUP BY smoker;

SELECT region, min(bmi), max(bmi), round(avg(bmi), 2) AS avg, round(stddev_pop(bmi), 2) AS stddev
FROM insurance
GROUP BY region;

SELECT sex, min(age), max(age), round(avg(age), 2) AS avg, round(stddev_pop(age), 2) AS stddev
FROM insurance
GROUP BY sex;

SELECT smoker, min(age), max(age), round(avg(age), 2) AS avg, round(stddev_pop(age), 2) AS stddev
FROM insurance
GROUP BY smoker;

SELECT region, min(age), max(age), round(avg(age), 2) AS avg, round(stddev_pop(age), 2) AS stddev
FROM insurance
GROUP BY region;

SELECT sex, min(charges), max(charges), round(avg(charges), 2) AS avg, round(stddev_pop(charges), 2) AS stddev
FROM insurance
GROUP BY sex;

SELECT smoker, min(charges), max(charges), round(avg(charges), 2) AS avg, round(stddev_pop(charges), 2) AS stddev
FROM insurance
GROUP BY smoker;

SELECT region, min(charges), max(charges), round(avg(charges), 2) AS avg, round(stddev_pop(charges), 2) AS stddev
FROM insurance
GROUP BY region;

-- Exploring the distribution of numeric data using TRUNCATE()

SELECT TRUNCATE(age, -1) AS truncated_age,
	COUNT(*)
FROM insurance
GROUP BY truncated_age;

SELECT TRUNCATE(bmi, -1) AS truncated_bmi,
	COUNT(*)
FROM insurance
GROUP BY truncated_bmi;

SELECT TRUNCATE(charges, -4) AS truncated_charges,
	COUNT(*)
FROM insurance
GROUP BY truncated_charges;

-- Exploring the average of numeric data and percentage of smokers

SELECT 
    -- Calculate average BMI, rounded to 2 decimal places
    ROUND(AVG(bmi), 2) AS average_bmi,

    -- Calculate average age, rounded to 1 decimal place
    ROUND(AVG(age), 1) AS average_age,

    -- Calculate average insurance charges, rounded to 3 decimal places
    ROUND(AVG(charges), 3) AS average_charges,

    -- Calculate average number of children per individual, rounded to 1 decimal place
    ROUND(AVG(children), 1) AS average_children,

    -- Calculate percentage of smokers in the dataset
    CONCAT(
        ROUND(100 * SUM(CASE WHEN smoker = 'yes' THEN 1 ELSE 0 END) 
        / (SELECT COUNT(*) FROM insurance), 2),
    '%') AS percentage_smokers
FROM insurance;

-- Exploring data in calculated 5 year age bins

DROP TABLE IF EXISTS bins;

-- Creates a temporary table with bins for age
CREATE TEMPORARY TABLE bins AS (
	SELECT 10 AS lower, 15 AS upper
	UNION ALL
	SELECT 15, 20
	UNION ALL
    SELECT 20, 25
	UNION ALL
	SELECT 25, 30
	UNION ALL
    SELECT 30, 35
    UNION ALL
    SELECT 35, 40
    UNION ALL
    SELECT 40, 45
    UNION ALL
    SELECT 45, 50
    UNION ALL
    SELECT 50, 55
    UNION ALL
    SELECT 55, 60
    UNION ALL
    SELECT 60, 65
    UNION ALL
    SELECT 65, 70);

-- Displays the bins to verify they were created correctly.
SELECT * FROM bins;
SELECT 
    lower,
    upper,
    COUNT(*) AS count,  -- Number of people in each age range
    ROUND(AVG(bmi), 2) AS average_bmi, -- Average BMI for the group
    MIN(bmi) AS min_bmi,  -- Minimum BMI in the group
    MAX(bmi) AS max_bmi,  -- Maximum BMI in the group
    CONCAT(ROUND(SUM(charges) / 1000, 1), 'k') total_charges, -- Total insurance costs in thousands
    CONCAT(ROUND(AVG(charges) / 1000, 1), 'k') AS average_charge -- Average insurance cost in thousands
    FROM bins AS b
LEFT JOIN insurance AS i ON i.age >= b.lower AND i.age < b.upper
GROUP BY b.lower, b.upper
ORDER BY b.lower;

-- Classifying individuals based on their BMI into three categories (overweight, normal weight, and underweight)
-- Calculation using charges field to check total, average and relative to the whole dataset average

SELECT
    CASE 
        -- Classifying as 'overweight' for BMI greater than 24.9
        WHEN bmi > 24.9 THEN 'overweight'
        
        -- Classifying as 'normal weight' for BMI between 18.5 and 24.9 (inclusive)
        WHEN bmi > 18.5 AND bmi <= 24.9 THEN 'normal weight'
        
        -- Classifying as 'underweight' for BMI less than or equal to 18.5
        ELSE 'underweight' 
    END AS weight, -- Weight category based on BMI
    
    COUNT(*) AS count, -- Counting the number of individuals in each BMI category
    
    -- Calculating the percentage of individuals in each weight category relative to the total number of records
    CONCAT(ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM insurance), 2), "%") AS percentage_of_total,
    
    -- Summing the charges for each weight category and displaying the total in thousands (rounded to 1 decimal)
    CONCAT(ROUND(SUM(charges) / 1000, 1), "k") AS total_charges, 
    
    -- Calculating the percentage of total charges that belong to each weight category
    CONCAT(ROUND(SUM(charges) / (SELECT SUM(charges) FROM insurance), 2), "%") AS percentage_charges,
    
    -- Calculating the average charges for each weight category, displaying it in thousands (rounded to 1 decimal)
    CONCAT(ROUND(AVG(charges) / 1000, 1), "k") AS average_charges,
    
    -- Comparing the average charges for each weight category to the global average charges
    ROUND(AVG(charges) / (SELECT AVG(charges) FROM insurance), 2) AS avg_to_global_avg_ratio
    
FROM insurance
GROUP BY weight;

-- Exploring group of patience that have charges above the average charges for the entire dataset

-- Using a CTE to filter the records with charges greater than the average
WITH cte AS (
    SELECT * 
    FROM insurance
    -- Filtering insurance records where charges are greater than the overall average
    WHERE charges > (SELECT AVG(charges) FROM insurance)
)

-- Calculating averages and percentage of smokers from the CTE
SELECT 
    ROUND(AVG(age), 1) AS average_age, -- Calculating the average age of individuals in the filtered records
    ROUND(AVG(children), 1) AS average_children, -- Calculating the average number of children in the filtered records
    ROUND(AVG(bmi), 2) AS average_bmi, -- Calculating the average BMI in the filtered records
    CONCAT(ROUND(AVG(charges)/1000, 1), "k") AS average_group_charges, -- Calculating the average charges in the filtered records
    CONCAT(ROUND((SELECT AVG(charges) FROM insurance)/1000, 1), "k") AS global_average_charges, -- subquery calculating average charges for the whole dataset
    -- Counting the number of smokers in the filtered records and dividing by the total number of records in the CTE to get the percentage
    CONCAT(ROUND(100*SUM(CASE 
            WHEN smoker = 'yes' THEN 1 ELSE 0 END) / (SELECT COUNT(*) FROM cte), 2), "%") AS percentage_smokers 
-- Using the filtered dataset (CTE) to perform the calculations
FROM cte; 

-- Checking if numeric data are different for different number of children a person have
-- Calculating total and percentage of charges, comparing it to percentage of count for the group
-- Calculating average of charges and comparing it to global charges for each group
-- Calculating percentage of smokers for each group

SELECT 
    children,  -- Number of children per insured individual
    COUNT(*) AS count,  -- Total number of individuals in each "children" category
    ROUND(AVG(age), 1) AS average_age,  -- Average age of individuals in each category

	-- Percentage of individuals in each "children" category relative to the entire dataset
    CONCAT(ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM insurance), 2), '%') AS percentage_count,

    -- Total insurance charges per "children" category (rounded to thousands and formatted with 'k')
    CONCAT(ROUND(SUM(charges) / 1000, 1), 'k') AS total_charges,

    -- Percentage of total insurance costs coming from each "children" category
    CONCAT(ROUND(100 * SUM(charges) / (SELECT SUM(charges) FROM insurance), 2), '%') AS percentage_charges,

    -- Average insurance charges per individual in each category (rounded to thousands)
    CONCAT(ROUND(AVG(charges) / 1000, 2), 'k') AS average_charges,

    -- Ratio of average insurance charges in this group to the overall dataset's average
    -- If >1, the group pays more than average; if <1, they pay less
    ROUND(AVG(charges) / (SELECT AVG(charges) FROM insurance), 3) AS avg_to_overall_avg,

    -- Percentage of smokers in each "children" category
    CONCAT(ROUND(100 * SUM(CASE WHEN smoker = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2), '%') AS percentage_smokers
FROM insurance
GROUP BY children
ORDER BY children ASC;

-- Exploring patients with top 150 charges: checking average bmi, age, average children count, smokers percentage and percentage of men and women

SELECT
    ROUND(AVG(age), 1) AS average_age, -- Calculating the average age of the top 150 records, rounded to 1 decimal place
    ROUND(AVG(bmi), 2) AS average_bmi, -- Calculating the average BMI of the top 150 records, rounded to 2 decimal places
    ROUND(AVG(children), 1) AS average_children, -- Calculating the average number of children of the top 150 records, rounded to 1 decimal place
    
    -- Calculating the percentage of smokers in the top 150 records
    CONCAT(ROUND(100*SUM(CASE 
            WHEN smoker = 'yes' THEN 1 ELSE 0 END) / COUNT(*), 2), "%") AS percentage_smokers,
	-- Calculating the percentage of men in the top 150 records
    CONCAT(ROUND(100*SUM(CASE 
            WHEN sex = 'male' THEN 1 ELSE 0 END) / COUNT(*), 2), "%") AS percentage_men,
	-- Calculating the percentage of women in the top 150 records
	CONCAT(100-ROUND(100*SUM(CASE 
            WHEN sex = 'male' THEN 1 ELSE 0 END) / COUNT(*), 2), "%") AS percentage_women
FROM (
    SELECT * 
    FROM insurance 
    ORDER BY charges DESC -- Sorting the records by charges from highest to lowest
    LIMIT 150 -- Selecting the top 150 records based on charges
) AS table1; -- Alias for the subquery to treat it as a temporary table (table1)

-- Exploring the smoker field: checking how does overweight percentage look for smokers and non-smokers and 
-- what percentage of people in those groups have charges higher than the average for the whole dataset

-- Calculating the percentage of overweight individuals and those with above-average charges, grouped by smoker status
SELECT 
    smoker,
        -- Calculating the percentage of overweight individuals (BMI >= 25)
    CONCAT(
        ROUND(100 * SUM(CASE 
            WHEN bmi >= 25 THEN 1 ELSE 0 END) / COUNT(smoker), 2), "%") AS percentage_overweight,
    -- Calculating the percentage of individuals with charges above the average
    CONCAT(
        ROUND(100 * SUM(CASE 
            WHEN charges > (SELECT AVG(charges) FROM insurance) THEN 1 ELSE 0 END) / COUNT(smoker), 2), "%") AS percentage_above_avg_charges
FROM insurance
GROUP BY smoker;

-- Exploring smoker category further - using window functions checking the highest charger withing smokers and non-smokers
-- and how they rank in the entire dataset 

-- Selecting top 20 ranked records based on charges for each smoker status (partitioned by smoker), with overall ranking
SELECT 
    rank_overall, -- Overall rank based on charges, from highest to lowest
    rank_partition, -- Rank within each smoker group, from highest to lowest charges
    idinsurance, -- Insurance ID for each record
    age, -- Age of the individual
    sex, -- Sex of the individual
    smoker, -- Smoker status (smoker/non-smoker)
    region, -- Region of the individual
    CONCAT(ROUND(charges / 1000, 2), "k") AS charges -- Charges in 'k' format (thousands), rounded to 2 decimal places
FROM (
    -- Subquery to calculate the ranks
    SELECT *, 
		-- Ranking all records overall based on charges (highest to lowest)
        RANK() OVER(ORDER BY charges DESC) AS rank_overall,
        -- Ranking records within each smoker group, based on charges (highest to lowest)
        RANK() OVER(PARTITION BY smoker ORDER BY charges DESC) AS rank_partition
    FROM insurance
) AS subquery
-- Filtering the records to only include the top 10 in each smoker group (based on charges)
WHERE rank_partition <= 20
ORDER BY smoker DESC, rank_partition ASC; -- Ordering the results by smoker status (smoker/non-smoker) and rank within the group 

-- Finally, identifying high risk indivuals by filtering entire data set for smokers and bmi greater than 30 with ordering from highest charges

SELECT 
    idinsurance, -- Insurance ID for each record
    age, -- Age of the individual
    sex, -- Sex of the individual
    bmi, -- BMI of the individual
    children, -- Number of children of the individual
    region, -- Region of the individual
    charges, -- Charges associated with the individual
    smoker -- Smoker status (yes/no)
FROM insurance
WHERE smoker = 'yes' -- Filter to include only smokers
    AND bmi > 30 -- Filter to include only individuals with BMI greater than 30 (overweight/obese)
ORDER BY charges DESC; -- Ordering the results by charges in descending order (highest charges first)
