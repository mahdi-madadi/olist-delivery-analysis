CREATE OR REPLACE VIEW delivery_metrics AS
SELECT
    order_id,
    customer_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    TIMESTAMPDIFF(
        SECOND,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) / 86400.0 AS delivery_duration_days,

    DATEDIFF(
        order_delivered_customer_date,
        order_estimated_delivery_date
    ) AS days_vs_estimate,

    CASE
        WHEN DATE(order_delivered_customer_date)
             > DATE(order_estimated_delivery_date)
        THEN 1
        ELSE 0
    END AS is_late
FROM delivery_analysis_orders;




SELECT
    COUNT(*) AS eligible_orders,
    SUM(is_late) AS late_orders,
    ROUND(100.0 * AVG(is_late), 2) AS late_delivery_pct,
    ROUND(AVG(delivery_duration_days), 2)
        AS average_delivery_days
FROM delivery_metrics;