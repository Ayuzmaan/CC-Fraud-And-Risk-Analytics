# Credit Card Fraud & Risk Analytics Dashboard (SQL + Power BI)

## Overview
This project demonstrates an end-to-end **fraud and risk analytics workflow**, combining SQL-based data modeling with an executive-level Power BI dashboard. The focus is on **decision-oriented analytics**, enabling risk monitoring, trend analysis, and investigative drill-through similar to real-world financial services use cases.

---

## Objectives
- Monitor overall fraud risk, exposure, and transaction activity  
- Identify fraud trends and period-over-period changes (MoM / YoY)  
- Analyze risk concentration across transaction categories  
- Compare fraud drivers by **volume vs value**  
- Enable drill-through investigation to transaction-level detail  

---

## Data & Assumptions
- All data used in this project is **synthetic** and created for analytical demonstration purposes only  
- No real customer, merchant, or financial institution data is included  
- The dashboard was built locally using **Power BI Desktop**  

---

## Data Modeling (SQL)
Raw transaction data was transformed in **SQLite** into an enriched fact table containing all core business logic, including:
- Fraud flags and fraud-score–based risk bands  
- Transaction-level tax (GST) calculation  
- Exposure metrics to represent financial risk impact  

Business logic was intentionally implemented in SQL to ensure consistency and reusability. Power BI was used for aggregation, time-based comparisons, and visualization.

SQL scripts used for data modeling are available in the `/sql` folder.

---

## Dashboard Design

### Executive Overview
The main dashboard page provides a consolidated view of:
- Key KPIs: Total Transactions, Fraud Rate, Spend, GST, and Exposure  
- Fraud rate trend with a defined risk threshold  
- Month-over-Month and Year-over-Year fraud rate change  
- Category-level comparison of **volume vs value** drivers  
- Distribution of fraud and exposure across risk bands  

This view is designed for **quick risk assessment and prioritization**.

### Drill-Through Analysis
A dedicated drill-through page supports deeper investigation by:
- Preserving context from the executive view (category, risk band, time period)  
- Allowing dynamic breakdown by **Bank** or **Card Type**  
- Displaying transaction-level details to support root-cause analysis  

---

## Screenshots
Key dashboard views are documented in the `/screenshots` folder, including:
- Executive overview  
- Fraud trend and MoM / YoY comparison  
- Category drivers by volume and value  
- Risk band distribution  
- Drill-through interaction and investigation view  

---

## Repository Structure
- data/ → Raw and modeled CSV files
- database/ → SQLite database
- powerbi/ → Power BI Desktop (.pbix) file and CSVs
- sql/ → SQL queries and transformations
- screenshots/ → Dashboard documentation images
  
---

## Tools & Skills
- SQL (SQLite) for data modeling and transformation  
- Power BI Desktop for dashboard design and analysis  
- DAX for KPIs, time intelligence, and comparative metrics  

---

## Notes
The Power BI `.pbix` file is included for reference and reproducibility. Screenshots are provided to document the dashboard experience, as publishing via Power BI Service was not used.

