# CHURN BY GENDER

SELECT
	gender,
    COUNT(*) AS total_customers,
    SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customers,
    ROUND(SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END )/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY gender
ORDER BY churn_rate DESC;

# CHURN BY SENIOR CITIZEN

SELECT
	CASE
		WHEN senior_citizen = 'Yes' THEN 'Senior Citizen'
        ELSE 'Non-Senior Citizen'
	END AS customer_type,
    COUNT(*) AS total_customers,
    SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END )/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY senior_citizen
ORDER BY churn_rate DESC;

# CHURN BY PARTNER STATUS

SELECT
	partner,
    COUNT(*) AS total_customers,
    SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END )/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY partner
ORDER BY churn_rate DESC;

# CHURN BY DEPENDENTS

SELECT
    dependents,
    COUNT(*) AS total_customers,
    SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customers,
    ROUND(SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END )/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY partner,dependents
ORDER BY churn_rate DESC;

# CHURN BY CONTRACT TYPE

SELECT
	contract_type,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY contract_type
ORDER BY churn_rate DESC;

# CHURN BY PAYMENT METHOD

SELECT
	payment_method,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND( SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END )/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY payment_method
ORDER BY churn_rate DESC;

# CHURN BY INTERNET SERVICE

SELECT
	internet_service,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY internet_service
ORDER BY churn_rate DESC;

# CHURN BY ONLINE SECURITY

SELECT
	online_security,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY online_security
ORDER BY churn_rate DESC;

# CHURN BY TECH SUPPORT

SELECT
	tech_support,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY tech_support
ORDER BY churn_rate DESC;

# CHURN BY TENURE GROUP

SELECT
	CASE
		WHEN tenure BETWEEN 0 AND 12 THEN '0-12 Months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13-24 Months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25-48 Months'
        ELSE '49+ Months'
	END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY tenure_group
ORDER BY churn_rate DESC;

# CHURN BY MONTHLY CHARGE BAND

SELECT
	CASE
		WHEN monthly_charges < 35 THEN 'Low charge'
        WHEN monthly_charges BETWEEN 35 AND 70 THEN 'Medium charge'
        ELSE 'High charge'
    END AS monthly_charge_band,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS churn_rate
FROM clean_teleco_churn
GROUP BY monthly_charge_band
ORDER BY churn_rate DESC;

# REVENUE LOST BY CONTRACT TYPE CHURN

SELECT
	contract_type,
	ROUND(SUM(monthly_charges * tenure),2) AS monthly_revenue_lost
FROM clean_teleco_churn
WHERE churn = 'Yes'
GROUP BY contract_type
ORDER BY monthly_revenue_lost DESC;

# REVENUE LOST BY PAYMENT METHOD

SELECT
	payment_method,
    ROUND(SUM(monthly_charges * tenure),2) AS monthly_revenue_lost
FROM clean_teleco_churn
WHERE churn = 'Yes'
GROUP BY payment_method
ORDER BY monthly_revenue_lost DESC;

# TOP20 HIGH VALUE CHURNED CUSTOMERS

SELECT
	customer_id,
    tenure,
    monthly_charges,
    total_charges,
    ROUND(monthly_charges * tenure,2) AS estimated_CLV,
    contract_type,
    payment_method
FROM clean_teleco_churn
WHERE churn = 'Yes'
ORDER BY estimated_CLV DESC
LIMIT 20;

# ACTIVE CUSTOMERS AT HIGH RISK

SELECT
	customer_id,
    tenure,
    monthly_charges,
    total_charges,
    contract_type,
    payment_method,
    internet_service,
    tech_support,
    online_security,
    ROUND(monthly_charges * tenure,2) AS estimated_CLV
FROM clean_teleco_churn
WHERE churn = 'Yes'
AND contract_type = 'Month-to-month'
AND tenure <= 12
AND monthly_charges >=70
ORDER BY estimated_CLV DESC;