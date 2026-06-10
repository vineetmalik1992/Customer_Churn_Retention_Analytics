# RISK SEGMENTATION

SELECT
	customer_id,
    tenure,
    monthly_charges,
    contract_type,
    payment_method,
    tech_support,
    online_security,
    churn,
    CASE
		WHEN contract_type = 'Month-to-month'
			AND tenure <= 12
            AND monthly_charges >70
		THEN 'High Risk'
        
        WHEN contract_type = 'Month-to-month'
			AND tenure <= 24
		THEN 'Medium Risk'
        
        WHEN contract_type IN ( 'One year', 'Two year')
			AND tenure >24
		THEN 'Low Risk'
		
        ELSE 'Medium Risk'
	END AS risk_segment
FROM clean_teleco_churn;

# CUSTOMERS BY RISK SEGMENT

WITH risk_table AS (
	SELECT
		customer_id,
        churn,
        CASE
			WHEN contract_type = 'Month-to-month'
				AND tenure <= 12
                AND monthly_charges >70
			THEN 'High Risk'
            
            WHEN contract_type = 'Month-to-month'
				AND tenure <=24
			THEN 'Medium Risk'
            
            WHEN contract_type IN ( 'One year', 'Two year')
				AND tenure >24
			THEN 'Low Risk'
            
            ELSE 'Medium Risk'
		END AS risk_segment
FROM clean_teleco_churn
)
SELECT
	risk_segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customers,
    ROUND(SUM( CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END )/COUNT(*),2) AS churn_rate
FROM risk_table
GROUP BY risk_segment
ORDER BY churn_rate DESC;