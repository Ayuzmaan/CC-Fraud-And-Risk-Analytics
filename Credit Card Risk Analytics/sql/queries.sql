-- Creating new table according to raw CSV data
CREATE TABLE transactions_raw (
   transaction_id INTEGER,
   customer_name TEXT,
   merchant_name TEXT,
   transaction_date DATE,
   transaction_amount REAL,
   fraud_risk TEXT,
   fraud_type TEXT,
   state TEXT,
   card_type TEXT,
   bank TEXT,
   is_fraud INTEGER,
   fraud_score INTEGER,
   transaction_category TEXT,
   merchant_location TEXT
   );
   
-- Raw data imported into the table using SQLite Studio's built-in tools

-- Sanity checks to see if everything is fine   
SELECT COUNT(*) from transactions_raw;
SELECT * FROM transactions_raw LIMIT 5;


-- New transactions_enriched table more suitable for risk and fraud analysis
CREATE TABLE transactions_enriched AS
   SELECT
      transaction_id,
      customer_name,
      merchant_name,
      transaction_date,
      
      --Extracting month column from transaction_date
      strftime('%Y-%m', transaction_date) AS transaction_month, 
      
      transaction_amount,
      
      --Adding gst_rate
      CASE  
         WHEN transaction_category IN ('FOOD Delivery', 'Groceries') THEN 0.05
         WHEN transaction_category IN ('Electronics', 'Travel') THEN 0.18
         WHEN transaction_category IN ('E-commerce', 'Apparel') THEN 0.12
         ELSE 0.12
      END AS gst_rate,
      
      --Adding derived column GST amount
      transaction_amount *
      CASE  
         WHEN transaction_category IN ('FOOD Delivery', 'Groceries') THEN 0.05
         WHEN transaction_category IN ('Electronics', 'Travel') THEN 0.18
         WHEN transaction_category IN ('E-commerce', 'Apparel') THEN 0.12
         ELSE 0.12
      END AS gst_amount,
      
      -- Adding risk fields
      fraud_type,
      fraud_risk,
      fraud_score,
      is_fraud,
      
      -- Adding risk_band      
      CASE
         WHEN fraud_score >= 76 THEN 'Very High'
         WHEN fraud_score >= 51 THEN 'High'
         WHEN fraud_score >= 26 THEN 'Medium'
         ELSE 'Low'
      END AS risk_band,
      
      -- Adding High_value flag
      CASE
         WHEN transaction_amount >= 15000 THEN 1
         ELSE 0
      END AS high_value_flag,
      
      -- Adding exposure_amount
      CASE
         WHEN is_fraud = 1 THEN transaction_amount
         else 0
      END AS exposure_amount,
      
      card_type,
      bank,
      transaction_category,
      state,
      merchant_location
      
  FROM transactions_raw;
  
SELECT * FROM transactions_enriched LIMIT 10;

--Creating a summary table to understand fraud/ risk metrics by merchant categories
CREATE TABLE merchant_risk_summary AS
   SELECT
      transaction_category,
      count(*) AS total_transactions,
      SUM(transaction_amount) AS total_transaction_amount,
      SUM(gst_amount) AS total_gst_amount,
      SUM(is_fraud) AS fraud_transactions,
      ROUND(AVG(transaction_amount),2) AS avg_transaction_amount,
      ROUND(CAST(SUM(is_fraud) AS FLOAT) / COUNT(*),4) AS fraud_rate,
      SUM(exposure_amount) AS total_exposure_amount
  FROM transactions_enriched
  GROUP BY transaction_category;

--Creating a summary table to understand fraud metrics by month
CREATE TABLE monthly_risk_base AS
SELECT
    transaction_month,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(
        CAST(SUM(is_fraud) AS FLOAT) / COUNT(*),
        4
    ) AS fraud_rate,
    SUM(exposure_amount) AS total_exposure_amount
FROM transactions_enriched
GROUP BY transaction_month;

--Creating a summary table to understand exposure by risk_band
CREATE TABLE exposure_summary AS
SELECT
    risk_band,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    SUM(exposure_amount) AS total_exposure_amount,
    ROUND(SUM(exposure_amount) / NULLIF(SUM(is_fraud), 0), 2) AS avg_exposure_per_fraud,
    ROUND(CAST(SUM(is_fraud) AS FLOAT) / COUNT(*),4) AS fraud_rate
FROM transactions_enriched
GROUP BY risk_band;

--Exported transactions_enriched.csv, monthly_risk_base.csv, merchant_risk_summary.csv, and exposure_summary.csv