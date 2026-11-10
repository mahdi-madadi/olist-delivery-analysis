USE olist_delivery_analysis;

CREATE TABLE orders_clean (
    order_id VARCHAR(32) PRIMARY KEY,
    customer_id VARCHAR(64) NOT NULL,
    order_status VARCHAR(50) NOT NULL,
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

INSERT INTO orders_clean (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    TRIM(order_id),
    TRIM(customer_id),
    LOWER(TRIM(order_status)),
    STR_TO_DATE(
        NULLIF(TRIM(order_purchase_timestamp), ''),
        '%Y-%m-%d %H:%i:%s'
    ),
    STR_TO_DATE(
        NULLIF(TRIM(order_approved_at), ''),
        '%Y-%m-%d %H:%i:%s'
    ),
    STR_TO_DATE(
        NULLIF(TRIM(order_delivered_carrier_date), ''),
        '%Y-%m-%d %H:%i:%s'
    ),
    STR_TO_DATE(
        NULLIF(TRIM(order_delivered_customer_date), ''),
        '%Y-%m-%d %H:%i:%s'
    ),
    STR_TO_DATE(
        NULLIF(TRIM(order_estimated_delivery_date), ''),
        '%Y-%m-%d %H:%i:%s'
    )
FROM raw_orders;

SHOW WARNINGS;

SELECT COUNT(*) AS cleaned_rows
FROM orders_clean;