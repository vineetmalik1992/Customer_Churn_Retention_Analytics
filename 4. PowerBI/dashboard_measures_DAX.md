# Power BI DAX Measures

## Total Customers

total_customers = DISTINCTCOUNT(dim_customer[customer_id])

## Churned Customers

churned_customers =
CALCULATE(
DISTINCTCOUNT(customer_churn_features[customer_id]),
customer_churn_features[churn] = "Yes"
)

## Active Customers

active_customers =
CALCULATE(
DISTINCTCOUNT(customer_churn_features[customer_id]),
customer_churn_features[churn] = "No"
)

## Churn Rate

churn_rate = DIVIDE([churned_customers],[total_customers],0)

## Retention Rate

retention_rate = DIVIDE([active_customers],[total_customers],0)

## Monthly Revenue Lost

monthly_revenue_lost =
CALCULATE(
sum(
fact_customer_revenue[monthly_charges]),
fact_customer_revenue[churn] = "Yes"
)

## Average CLV

average_CLV =
AVERAGEX(
customer_churn_features,
customer_churn_features[monthly_charges]*customer_churn_features[tenure]
)

## High Risk Customers

high_risk_customers =
CALCULATE(
DISTINCTCOUNT(customer_churn_features[customer_id]),
customer_churn_features[risk_segment] = "High Risk",
customer_churn_features[churn] = "No"
)

## High Risk Revenue Exposure

High_Risk Revenue Exposure =
CALCULATE(
SUM(customer_churn_features[monthly_charges]),
customer_churn_features[risk_segment] = "High Risk",
customer_churn_features[churn] = "No"
)

## CLV Lost

CLV_lost =
CALCULATE(
SUM(fact_customer_revenue[CLV]),
fact_customer_revenue[churn] = "Yes"
)

