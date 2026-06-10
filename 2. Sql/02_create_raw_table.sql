USE Customer_Churn_Retention;

## RAW TABLE
CREATE TABLE raw_teleco_churn (
	customer_id VARCHAR(50),
    gender VARCHAR(10),
    senior_citizen INT,
    partner VARCHAR(10),
    dependents VARCHAR(10),
    tenure INT,
    phone_service VARCHAR(10),
    multiple_lines VARCHAR(50),
    internet_service VARCHAR(50),
    online_security VARCHAR(50),
    online_backup VARCHAR(50),
    device_protection VARCHAR(50),
    tech_support VARCHAR(50),
    streaming_tv VARCHAR(50),
    streaming_movies VARCHAR(50),
    contract_type VARCHAR(50),
    paperless_billing VARCHAR(10),
    payment_method VARCHAR(100),
    monthly_charges DECIMAL(10,2),
    total_charges VARCHAR(50),
    churn varchar(10)
);