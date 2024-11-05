-- Query 1: List of Clients with Continuous History for the Year
SELECT Id_client,
       COUNT(DISTINCT DATE_FORMAT(date_new, '%Y-%m')) AS months_with_transactions,
       AVG(Sum_payment) AS avg_receipt,
       SUM(Sum_payment) / 12 AS avg_monthly_purchases,
       COUNT(*) AS total_transactions
FROM transactions_info
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY Id_client
HAVING months_with_transactions = 12;



-- Query 2: Monthly Average Check Amount and Operations
-- Monthly Average Check Amount and Operations
SELECT DATE_FORMAT(date_new, '%Y-%m') AS month,
       AVG(Sum_payment) AS avg_check_amount,
       COUNT(*) AS avg_transactions,
       COUNT(DISTINCT Id_client) AS unique_clients
FROM transactions_info
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month;

-- Share of Total Transactions and Gender Ratio
SELECT DATE_FORMAT(date_new, '%Y-%m') AS month,
       COUNT(*) / (SELECT COUNT(*) FROM transactions_info WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01') * 100 AS share_of_total_transactions,
       SUM(CASE WHEN Gender = 'M' THEN Sum_payment ELSE 0 END) / SUM(Sum_payment) * 100 AS male_share,
       SUM(CASE WHEN Gender = 'F' THEN Sum_payment ELSE 0 END) / SUM(Sum_payment) * 100 AS female_share,
       SUM(CASE WHEN Gender = 'NA' THEN Sum_payment ELSE 0 END) / SUM(Sum_payment) * 100 AS na_share
FROM transactions_info
JOIN customer_info ON transactions_info.Id_client = customer_info.Id_client
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY month;



-- Query 3: Age Groups in 10-Year Increments
SELECT FLOOR(Age / 10) * 10 AS age_group,
       QUARTER(date_new) AS quarter,
       AVG(Sum_payment) AS avg_amount,
       COUNT(*) AS transaction_count,
       COUNT(*) / (SELECT COUNT(*) FROM transactions_info WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01') * 100 AS transaction_percentage
FROM transactions_info
JOIN customer_info ON transactions_info.Id_client = customer_info.Id_client
WHERE date_new BETWEEN '2015-06-01' AND '2016-06-01'
GROUP BY age_group, quarter;