USE olist_delivery_analysis;

CREATE OR REPLACE VIEW delivery_dashboard AS
SELECT
    order_id,
    customer_state,
    CAST(DATE_FORMAT(order_purchase_timestamp, '%Y-%m-01') AS DATE)
        AS purchase_month,
    delivery_duration_days,
    days_vs_estimate,
    is_late,
    review_score,
    CASE
        WHEN days_vs_estimate <= 0 THEN 'On time'
        WHEN days_vs_estimate <= 3 THEN '1–3 days late'
        WHEN days_vs_estimate <= 7 THEN '4–7 days late'
        ELSE '8+ days late'
    END AS delay_band,
    CASE
        WHEN days_vs_estimate <= 0 THEN 0
        WHEN days_vs_estimate <= 3 THEN 1
        WHEN days_vs_estimate <= 7 THEN 2
        ELSE 3
    END AS delay_band_sort
FROM delivery_review_state_metrics;

SELECT
    COUNT(*) AS eligible_orders,
    SUM(is_late) AS late_orders,
    COUNT(review_score) AS reviewed_orders
FROM delivery_dashboard;