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

