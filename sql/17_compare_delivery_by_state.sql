SELECT
    customer_state,
    COUNT(*) AS eligible_orders,
    SUM(is_late) AS late_orders,
    ROUND(100.0 * AVG(is_late), 2) AS late_delivery_pct
FROM delivery_review_state_metrics
GROUP BY customer_state
ORDER BY late_orders DESC, customer_state;


SELECT
    customer_state,
    COUNT(*) AS eligible_orders,
    SUM(is_late) AS late_orders,
    ROUND(100.0 * AVG(is_late), 2) AS late_delivery_pct
FROM olist_delivery_analysis.delivery_review_state_metrics
GROUP BY customer_state
HAVING COUNT(*) >= 100
ORDER BY AVG(is_late) DESC, customer_state ASC
LIMIT 5;