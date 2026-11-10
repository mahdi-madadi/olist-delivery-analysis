CREATE OR REPLACE VIEW delivery_analysis_orders AS
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date >= order_purchase_timestamp
  AND DATE(order_estimated_delivery_date)
      >= DATE(order_purchase_timestamp);