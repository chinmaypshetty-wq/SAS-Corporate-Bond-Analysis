# Predictive & Visual Analytics: U.S. Corporate Bond Yields

## Project Overview
This project analyzes the U.S. corporate bond market to identify key factors influencing bond yields. [cite_start]Using **SAS**, I performed comprehensive data cleansing, statistical analysis, and developed multiple regression models to predict yields based on variables such as credit rating, bond seniority, and market of issue[cite: 263, 267].

## Key Objectives
* [cite_start]**Data Preprocessing:** Cleaned a raw dataset of over 4,000 observations by removing duplicates, handling null values, and treating outliers[cite: 331, 333].
* [cite_start]**Statistical Analysis:** Conducted univariate analysis and visualizations (heat maps, histograms) to understand variable distributions[cite: 271, 46].
* [cite_start]**Predictive Modeling:** Built three linear regression models to test the impact of bond characteristics on yield[cite: 274].

## Methodology
* [cite_start]**Tools:** SAS OnDemand, SAS Viya[cite: 268].
* **Techniques:**
    * [cite_start]Log transformation of `Amount_outstanding` to normalize skewed data[cite: 355].
    * [cite_start]Variance Inflation Factor (VIF) testing to ensure no multicollinearity[cite: 278].
    * [cite_start]Heteroscedasticity testing to validate model assumptions[cite: 545].

## Key Findings
* [cite_start]**Market Influence:** Bonds issued in the domestic market showed different yield behaviors compared to global issues, highlighting the importance of market liquidity and risk perception[cite: 276, 587].
* [cite_start]**Model Performance:** The analysis revealed that standard bond characteristics (coupon, maturity) had low predictive power in this specific dataset (R-squared < 1%), suggesting that external macroeconomic factors or non-linear relationships may drive yields in this sample[cite: 418, 456].
* [cite_start]**Credit Ratings:** Investment-grade ratings (Baa2, Baa3) dominated the dataset, heavily influencing the risk profile analyzed[cite: 127].

## File Structure
* `bond_yield_analysis.sas`: The complete SAS source code for data import, cleaning, and regression.
* `Bond_Yield_Analysis_Report.pdf`: Detailed business report explaining the statistical interpretation and business outcomes.
