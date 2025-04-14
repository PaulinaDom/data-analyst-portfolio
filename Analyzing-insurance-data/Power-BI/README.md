# 📊 Analyzing Patients' Health Insurance Data

## 📄 Project Description  
This Power BI project analyzes a dataset containing health insurance records to provide insights into how various factors like age, gender, BMI, smoking status, and family size impact insurance charges. The goal was to build an interactive report summarizing patient profiles and uncover meaningful patterns within the data.

---

## 📚 Dataset  
The dataset was sourced from Kaggle and contains the following attributes:

- **idinsurance:** Unique identifier for each record  
- **age:** Age of the individual  
- **sex:** Gender of the insured individual  
- **bmi:** Body Mass Index (BMI)  
- **children:** Number of children covered under the insurance plan  
- **smoker:** Whether the individual is a smoker (yes or no)  
- **region:** The region where the insured individual resides  
- **charges:** Total insurance charges for the individual  

🔗 [**Dataset link (to be added)**]()

---

## 🎯 Project Objectives  
The main objective was to create a comprehensive overview of patient profiles and examine how insurance charges are influenced by different factors such as age, smoking habits, BMI, and number of children.

---

## 📊 Report Features  

The interactive Power BI report includes:
- **Visualizations:**  
  - Bar charts  
  - Line charts  
  - Line and column combo charts  
  - Column and clustered column charts  
  - Scatter plots  
  - Pie charts  
  - Cards  
  - Tables  
  - Slicers and navigation buttons  

- **DAX Measures Created:**  
  - Minimum and maximum age  
  - Count of patients by weight category  
  - Average values for various factors using the `CALCULATE()` function (e.g., average charges for non-smokers)

- **Data Transformation:**  
  - Data cleaning and validation using **Power Query** (checking column distribution, profiling)  
  - Added index column, age bins, BMI bins  
  - Categorized BMI into three weight categories: **underweight**, **normal weight**, **overweight**

---

## 📌 Key Insights  

- The dataset is gender-balanced: **50% women and 50% men**
- All age groups are similarly represented  
- Insurance **charges increase with age** (average, median, and total)  
- **20.5% of patients are smokers**, of whom **58% are men**
- Smokers make up **20.5% of patients but contribute to 49% of total charges**
- On average, **smokers incur 4x higher average charges and almost 5x higher median charges** than non-smokers
- Scatter plots show **smokers consistently have higher charges than non-smokers**
- **81.9% of patients are overweight**, with the percentage rising by **10 percentage points with age**
- Overweight patients contribute to **86% of total insurance charges**
- Patients with **1–3 children** tend to have the highest insurance charges

---

## 💾 How to Use  

- Download the `.pbix` file from this repository.  
- The report contains **6 interactive pages**.  
- Use the **arrow buttons in the top-right corner** of each page to navigate through the report.

---

## 🛠️ Tools & Technologies  
- **Power BI** (Power Query, DAX, Power BI Service for report building)  
- **Power Query** for data cleaning, transformations, and feature creation  
- **DAX** for calculated measures and KPIs  

---

## 📚 Lessons Learned  
This project helped strengthen my skills in **data cleaning with Power Query**, **building DAX measures**, and **designing multi-page, interactive Power BI reports**. It also emphasized the importance of clear data visualization in uncovering actionable business insights.


