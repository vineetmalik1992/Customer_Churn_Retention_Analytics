# TOTAL CUSTOMERS

SELECT COUNT(DISTINCT customer_id) AS Total_customers
FROM clean_teleco_churn;

# CHURNED CUSTOMERS

SELECT COUNT(*) AS Churned_customers
FROM clean_teleco_churn
WHERE churn = 'Yes';

# ACTIVE CUSTOMERS

SELECT COUNT(*) AS Active_customers
FROM clean_teleco_churn
WHERE churn = 'No';

# CHURN RATE

SELECT
	ROUND(
			SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END )/COUNT(*), 2
		) AS churn_rate
FROM clean_teleco_churn;

# RETENTION RATE

SELECT
	ROUND(
			SUM( CASE WHEN churn = 'No' THEN 1 ELSE 0 END )/ COUNT(*), 2
		) AS retention_rate
FROM clean_teleco_churn;

# AVERAGE TENURE

SELECT
	ROUND(AVG(tenure),2) AS average_tenure
FROM clean_teleco_churn;

# AVERAGE MONTHLY CHAGE

SELECT
	ROUND(AVG(monthly_charges),2) AS average_monthly_charges
FROM clean_teleco_churn;

# TOTAL MONTHLY REVENUE

SELECT
	ROUND(SUM(monthly_charges),2) AS total_monthly_revenue
FROM clean_teleco_churn
WHERE churn = 'No';

# REVENUE LOST DUE TO CHURN

SELECT
	ROUND(SUM(monthly_charges),2) AS monthly_revenue_lost
FROM clean_teleco_churn
WHERE churn = 'Yes';

# AVERAGE CLV

SELECT
	ROUND(AVG(monthly_charges * tenure),2) AS average_estimated_CLV
FROM clean_teleco_churn;

# CHURNED CUSTOMER CLV LOSS

SELECT
	ROUND(SUM(monthly_charges * tenure),2 ) AS CLV_lost_from_churned_customers
FROM clean_teleco_churn
WHERE churn = 'Yes';

# HIGH RISK ACTIVE CUSTOMERS

SELECT COUNT(*) AS high_risk_active_customers
FROM clean_teleco_churn
WHERE churn = 'No'
AND contract_type = 'Month-to-month'
AND tenure <= 12
AND monthly_charges >= 70;