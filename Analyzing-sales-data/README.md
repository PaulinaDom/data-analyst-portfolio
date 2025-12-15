# Power BI Sales Performance Dashboard (YTD vs PYTD Analysis)

## 📌 Project Overview

This project is a *Power BI sales performance dashboard* focused on *Year-to-Date (YTD) vs Prior Year-To-Date (PYTD)* analysis.  
The report allows users to dynamically analyze *Sales, Quantity, and Gross Profit* across multiple dimensions such as *time, country, customer account, and product hierarchy*.

The key goal of the dashboard is to:
- Compare current performance against the previous year
- Identify positive and negative performance drivers
- Enable flexible metric switching using slicers
- Follow Power BI best practices in *data modeling (star schema) and DAX design*

> ⚠ *Credit*:  
> This portfolio project is based on a tutorial and dataset created by *Mo Chen*.  
> The original idea, dataset, and guidance come from:
> - GitHub repository: https://github.com/mochen862/power-bi-portfolio-project  
> - YouTube video: https://youtu.be/BLxW9ZSuuVI  
>
> This repository represents *my own implementation*, with a focus on:
> - Understanding and explaining each modeling and DAX decision  
> - Writing clean documentation  
> - Applying Power BI best practices end-to-end  

---

## 🗂 Data Source & Dataset Description

### Data Source
The dataset is provided as a .csv file with multiple tables in the original GitHub repository and represents *sales transaction data* for years 2022, 2023 and 2024.

### Data Coverage
- *Date range*: 01.01.2022 – 31.12.2024
- *Granularity*: One row per sales transaction
- *Currency*: USD
- *Main business process*: Sales transactions including revenue, quantity, and cost with information about what products in which country has been sold

### Main Tables

#### Fact Table
*Fact_Sales*
- Contains transactional sales data
- Key columns include:
  - Product_id – product identification number
  - Account_id – account identification number
  - Date – transaction date
  - Sales_USD – sales revenue
  - Quantity – number of units sold
  - COGS_USD – cost of goods sold
- This table is the *central fact table* in the data model

#### Dimension Tables
The dataset includes several dimension tables that provide descriptive context:
- *Dim_Date* – calendar table for time intelligence - created in Power BI using DAX
- *Dim_Customer / Account* – customer-level information
- *Dim_Product* – product hierarchy (type and name)
- *Dim_Country* – geographical dimension

Each dimension table follows a *one-to-many relationship* with the fact table.

---

## 🧹 Data Cleaning & Transformation (Power Query)

Before loading the data into the Power BI model, several cleaning and preparation steps were performed:

1. *Initial inspection in Excel*
   - Reviewed raw .csv file to understand structure and data quality

2. *Importing required tables into Power Query*
   - Only relevant tables were loaded into the model

3. *Removing duplicates*
   - Ensured uniqueness in dimension tables to avoid relationship issues

4. *Renaming tables and columns*
   - Converted technical or unclear names into *business-friendly, readable names*
   - Fixed typos and inconsistencies

5. *Data type validation*
   - Dates, numeric values, and text fields were validated and corrected

6. *Loading cleaned data into Power BI*
   - Ensured a clean foundation before modeling and DAX creation

---

## 🧠 Data Model & Star Schema Design

The report follows a *Star Schema* design, which is the recommended modeling approach for Power BI:

- *Fact_Sales* at the center
- Dimension tables connected via one-to-many relationships
- Single-direction filtering from dimensions to fact table

### Key Modeling Decisions
- Relationships that were not automatically detected were *manually created*
- A dedicated *Date table (Dim_Date)* was created to support time intelligence
- Clear separation between *facts, dimensions, and measures*

---

## 📅 Date Table & Time Intelligence

### Date Table Creation
A custom Dim_Date table was created covering the full dataset range in years:
- *Start*: 01.01.2022
- *End*: 31.12.2024

### InPast Calculated Column
To enable correct *PYTD calculations*, a calculated column was added to identify whether a date can be used to compared to a valid previous-year date.

```DAX
Inpast = 
VAR lastsalesdate = MAX(Fact_Sales[Date])
VAR lastsalesdatePY = EDATE(lastsalesdate, -12)
RETURN
    Dim_Date[Date] <= lastsalesdatePY
```

This ensures that PYTD values are calculated only whena valid comparison exists.

## 📅 Measures Deisgn (DAX)

### Measures Table
A dedicated table called "MEasures where created to keep all measures in one place at the top of the tables list. This improves organization and makes the navigation easier for future maintenence.

### Base Measures
```DAX
Sales = SUM(Fact_Sales[Sales_USD])
Quantity = SUM(Fact_Sales[quantity])
Cost of Goods = SUM(Fact_Sales[COGS_USD])
Gross Profit = [Sales] - [Cost of Goods]
% Gross Profit = DIVIDE([Gross Profit], [Sales])
```

### YEar-to-date Measures
```DAX
YTD_Sales = TOTALYTD([Sales], Fact_Sales[Date])
YTD_Quantity = TOTALYTD([Quantity], Fact_Sales[Date])
YTD_GrossProfit = TOTALYTD([Gross Profit], Fact_Sales[Date])
```

### Prior-Year-to-date Measures
```DAX
PYTD_Sales = 
CALCULATE(
    [Sales],
    SAMEPERIODLASTYEAR(Dim_Date[Date]),
    Dim_Date[Inpast] = TRUE
)

PYTD_Quantity = 
CALCULATE(
    [Quantity],
    SAMEPERIODLASTYEAR(Dim_Date[Date]),
    Dim_Date[Inpast] = TRUE
)

PYTD_Gross_Profit = 
CALCULATE(
    [Gross Profit],
    SAMEPERIODLASTYEAR(Dim_Date[Date]),
    Dim_Date[Inpast] = TRUE
)
```

## 🔀 Dynamic Metric Switching

### Slicer Values Table
A disconnected from the rest of the model Slicer_values table was created with one column containing three rows with following values:
- Sales
- Quantity
- Gross Profit
This table is used to dynamically switch metrics across the report.

### Switch measures
Switch measures were created to make the Base, YTD and PYTD measures dynamic - a user can switch between those depending on which value is selected in the slicer based on the Slicer_values table.
```DAX
Switch_PYTD = 
VAR
    selected_value = SELECTEDVALUE(Slicer_values[Values])
VAR
    result = SWITCH(selected_value,
        "Sales", [PYTD_Sales],
        "Quantity", [PYTD_Quantity],
        "Gross Profit", [PYTD_Gross_Profit],
        BLANK()
    )
RETURN
result


Switch_YTD = 
VAR
    selected_value = SELECTEDVALUE(Slicer_values[Values])
VAR
    result = SWITCH(selected_value,
        "Sales", [YTD_Sales],
        "Quantity", [YTD_Quantity],
        "Gross Profit", [YTD_GrossProfit],
        BLANK()
    )
RETURN
result


YTD vs PYTD = [Switch_YTD] - [Switch_PYTD]
```
## 📊 Visual Design and User Experience

