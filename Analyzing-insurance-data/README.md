# Health Insurance Data Analysis Using SQL

- - - -

## Project Overview

This project showcases SQL skills by exploring a health insurance dataset. The analysis focuses on extracting meaningful insights using advanced SQL queries, including aggregations, window functions, and common table expressions (CTEs).

### The key objectives of this analysis are:

  * Calculating averages and distributions for key numeric fields

* Grouping data based on BMI, age, and smoker status

* Analyzing insurance charges in different demographic categories

* Using window functions to rank high-cost individuals

* Identifying high-risk individuals based on health metrics

## Dataset Description

The dataset used in this project contains health insurance records with the following attributes:

* idinsurance: Unique identifier for each record

* age: Age of the individual

* sex: Gender of the insured individual

* bmi: Body Mass Index (BMI)

* children: Number of children covered under the insurance plan

* smoker: Whether the individual is a smoker (yes or no)

* region: The region where the insured individual resides

* charges: Total insurance charges for the individual

## Analysis and Insights

#### 1. General Statistics and Smoking Trends

* Computed average BMI, age, insurance charges, and children per individual.

* Calculated the percentage of smokers in the dataset.

#### 2. Age Group Analysis (5-Year Bins)

* Created a temporary table for age bins (e.g., 10-15, 15-20, etc.).

* Aggregated data to analyze BMI, total insurance costs, and average charges per age group.

#### 3. BMI Classification

* Categorized individuals into overweight, normal weight, and underweight based on BMI.

* Compared insurance charges across BMI categories.

* Measured the percentage of total insurance costs attributed to each BMI group.

#### 4. High-Cost Individuals (Above Average Charges)

* Used a CTE to filter individuals with charges above the dataset's average.

* Analyzed their average age, children count, BMI, and smoking percentage.

#### 5. Impact of Children on Charges and Smoking Trends

* Examined how the number of children affects insurance charges and smoking rates.

* Compared total and average insurance charges across different family sizes.

#### 6. Top 150 Insurance Charges

* Extracted the top 150 highest charges.

* Analyzed their age, BMI, number of children, smoking percentage, and gender distribution.

#### 7. Smoker vs. Non-Smoker Comparison

* Compared the percentage of overweight individuals between smokers and non-smokers.

* Evaluated how many individuals in each group had insurance charges above the dataset's average.

#### 8. High-Cost Rankings Using Window Functions

* Used RANK() to rank individuals by insurance charges within smoker and non-smoker groups.

* Extracted the top 20 highest charges for each smoker category.

#### 9. High-Risk Individuals

* Identified high-risk individuals as smokers with a BMI above 30.

* Sorted them based on their insurance charges in descending order.

## SQL Techniques Used

* **Aggregations** (AVG(), SUM(), COUNT(), MIN(), MAX())

* **GROUP BY** clause

* **Conditional Aggregations** (CASE WHEN for classification and filtering)

* **Common Table Expressions** (CTEs) for better query structuring

* **Subqueries** within **SELECT, FROM and WHERE** for prefiltering data or calculating measures beforehand

* **Temporary Tables** for dynamic binning of age groups

* **Window Functions** (RANK() OVER() for ranking high-cost individuals)

* **String Manipulation** (CONCAT() to format outputs for percentage values or higher numbers for charges category)

## Conclusion

This analysis provides valuable insights into the relationship between health metrics, smoking habits, and insurance costs. It also demonstrates the use of advanced SQL techniques to manipulate and extract meaningful data trends.

## Next Steps

Potential improvements or extensions of this project:

* Use SQL joins to incorporate additional datasets to derive more insights (e.g., medical history, hospital visits).

* Visualize key findings using Power BI or Tableau for a more interactive presentation.
