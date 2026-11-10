USE olist_delivery_analysis;

CREATE TABLE raw_customers (
    customer_id VARCHAR(64),
    customer_unique_id VARCHAR(64),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);


SELECT
    COUNT(*) AS imported_rows,
    COUNT(DISTINCT customer_id) AS distinct_customer_ids,
    COUNT(DISTINCT customer_state) AS distinct_states
FROM raw_customers;

use olist_delivery_analysis;
