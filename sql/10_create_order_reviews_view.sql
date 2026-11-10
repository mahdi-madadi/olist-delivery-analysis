CREATE OR REPLACE VIEW order_reviews_one_per_order AS
WITH ranked_reviews AS (
    SELECT
        TRIM(order_id) AS order_id,
        TRIM(review_id) AS review_id,
        CAST(TRIM(review_score) AS UNSIGNED) AS review_score,
        TRIM(review_timestamp) AS review_answer_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(order_id)
            ORDER BY TRIM(review_timestamp) DESC, TRIM(review_id)
        ) AS review_rank
    FROM raw_reviews
)
SELECT
    order_id,
    review_id,
    review_score,
    review_answer_timestamp
FROM ranked_reviews
WHERE review_rank = 1;

SELECT
    COUNT(*) AS review_rows,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM order_reviews_one_per_order;