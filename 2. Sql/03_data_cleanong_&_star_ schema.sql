/* Count the number of rows*/

SELECT COUNT(*) AS Total_Rows 
FROM raw_teleco_churn;

/* Check duplicate Customer ID */

SELECT customer_id, COUNT(*) AS Duplicate_ID
FROM raw_teleco_churn
GROUP BY customer_id
HAVING COUNT(*) > 1;

/* Check Missing Values */

SELECT 
	SUM( CASE WHEN customer_id IS NULL OR customer_id = '' THEN 1 ELSE 0 END ) AS missing_customer_id,
    SUM( CASE WHEN gender IS NULL OR gender = '' THEN 1 ELSE 0 END ) AS missing_gender,
    SUM( CASE WHEN tenure IS NULL OR tenure = '' THEN 1 ELSE 0 END ) AS missing_tenure,
    SUM( CASE WHEN monthly_charges IS NULL OR monthly_charges = '' THEN 1 ELSE 0 END ) AS missing_monthly_charges,
    SUM( CASE WHEN total_charges IS NULL OR total_charges = '' THEN 1 ELSE 0 END ) AS missing_total_charges,
    SUM( CASE WHEN churn IS NULL OR churn = '' THEN 1 ELSE 0 END ) AS missing_churn
FROM raw_teleco_churn;
    
/* Identify Blank Records*/

SELECT * FROM raw_teleco_churn
WHERE total_charges IS NULL
	OR total_charges = ''
    OR TRIM(total_charges) = ''; 

/* Create a clean table without missing values*/

CREATE TABLE clean_teleco_churn AS
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract_type,
    paperless_billing,
    payment_method,
    monthly_charges,
    CASE 
        WHEN total_charges IS NULL OR total_charges = '' OR TRIM(total_charges) = '' THEN 0
        ELSE CAST(total_charges AS DECIMAL(10,2))
    END AS total_charges,
    churn
FROM raw_teleco_churn;

SELECT * FROM clean_teleco_churn;

/* Standardize categorical Values */

UPDATE clean_teleco_churn
SET 
    gender = TRIM(gender),
    partner = TRIM(partner),
    dependents = TRIM(dependents),
    phone_service = TRIM(phone_service),
    multiple_lines = TRIM(multiple_lines),
    internet_service = TRIM(internet_service),
    online_security = TRIM(online_security),
    online_backup = TRIM(online_backup),
    device_protection = TRIM(device_protection),
    tech_support = TRIM(tech_support),
    streaming_tv = TRIM(streaming_tv),
    streaming_movies = TRIM(streaming_movies),
    contract_type = TRIM(contract_type),
    paperless_billing = TRIM(paperless_billing),
    payment_method = TRIM(payment_method),
    churn = TRIM(churn);

/* Create a Star Schema */

CREATE TABLE dim_customer AS
SELECT	
	customer_id,
    gender,
    senior_citizen,
    partner,
    dependents
FROM clean_teleco_churn;
    
CREATE TABLE dim_services AS
SELECT	
	customer_id,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies
FROM clean_teleco_churn;

CREATE TABLE dim_contract AS
SELECT
	customer_id,
    contract_type,
    paperless_billing,
    payment_method
FROM clean_teleco_churn;

CREATE TABLE fact_customer_revenue AS
SELECT
	customer_id,
    tenure,
    monthly_charges,
    total_charges,
    churn,
    CASE 
		WHEN churn = 'Yes' THEN 1
		ELSE 0
    END AS Churn_flag
FROM clean_teleco_churn;

CREATE TABLE customer_churn_features AS
SELECT
	customer_id,
    tenure,
    monthly_charges,
    total_charges,
    churn,
    CASE
		WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        ELSE '49+ Months'
	END AS tenure_group,
    CASE
		WHEN monthly_charges < 35 THEN 'Low charge'
        WHEN monthly_charges BETWEEN 35 AND 70 THEN 'Medium charge'
        ELSE 'High charge'
    END AS monthly_charge_band,
    monthly_charges * tenure AS clv_estimate
FROM clean_teleco_churn;