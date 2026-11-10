USE olist_delivery_analysis;

CREATE OR REPLACE VIEW delivery_review_state_metrics AS
SELECT
    d.*,
    r.review_score,
    UPPER(NULLIF(TRIM(c.customer_state), '')) AS customer_state
FROM delivery_metrics AS d
LEFT JOIN order_reviews_indexed AS r
    ON d.order_id = r.order_id
LEFT JOIN raw_customers AS c
    ON d.customer_id = c.customer_id;

SELECT
    COUNT(*) AS eligible_orders,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT customer_state) AS distinct_states,
    COUNT(*) - COUNT(customer_state) AS orders_without_state,
    SUM(is_late) AS late_orders
FROM delivery_review_state_metrics;