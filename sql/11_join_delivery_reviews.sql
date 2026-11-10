USE olist_delivery_analysis;

CREATE OR REPLACE VIEW delivery_review_metrics AS
SELECT
    d.*,
    r.review_score
FROM delivery_metrics AS d
LEFT JOIN order_reviews_one_per_order AS r
    ON d.order_id = r.order_id;

SELECT
    COUNT(*) AS eligible_orders,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(review_score) AS orders_with_review,
    COUNT(*) - COUNT(review_score) AS orders_without_review,
    SUM(is_late) AS late_orders
FROM delivery_review_metrics;