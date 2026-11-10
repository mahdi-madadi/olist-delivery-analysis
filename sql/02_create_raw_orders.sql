USE olist_delivery_analysis;

CREATE TABLE raw_orders (
    order_id VARCHAR(64),
    customer_id VARCHAR(64),
    order_status VARCHAR(50),
    order_purchase_timestamp VARCHAR(50),
    order_approved_at VARCHAR(50),
    order_delivered_carrier_date VARCHAR(50),
    order_delivered_customer_date VARCHAR(50),
    order_estimated_delivery_date VARCHAR(50)
);

SHOW COLUMNS FROM raw_orders;