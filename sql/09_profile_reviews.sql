SELECT
    COUNT(*) AS review_rows,
    COUNT(DISTINCT NULLIF(TRIM(review_id), '')) AS distinct_review_ids,
    COUNT(DISTINCT NULLIF(TRIM(order_id), '')) AS distinct_order_ids,
    SUM(CASE
        WHEN NULLIF(TRIM(order_id), '') IS NULL THEN 1 ELSE 0
    END) AS missing_order_ids,
    SUM(CASE
        WHEN review_score IS NULL
          OR TRIM(review_score) NOT IN ('1', '2', '3', '4', '5')
        THEN 1 ELSE 0
    END) AS invalid_or_missing_scores
FROM raw_reviews;



WITH reviews_per_order AS (
    SELECT TRIM(order_id) AS order_id, COUNT(*) AS review_count
    FROM raw_reviews
    WHERE NULLIF(TRIM(order_id), '') IS NOT NULL
    GROUP BY TRIM(order_id)
)
SELECT
    COUNT(*) AS orders_with_multiple_reviews,
    MAX(review_count) AS max_reviews_for_one_order
FROM reviews_per_order
WHERE review_count > 1;






WITH repeated_orders AS (
    SELECT
        TRIM(order_id) AS order_id,
        COUNT(DISTINCT TRIM(review_score)) AS distinct_scores
    FROM raw_reviews
    GROUP BY TRIM(order_id)
    HAVING COUNT(*) > 1
)
SELECT
    SUM(CASE WHEN distinct_scores = 1 THEN 1 ELSE 0 END)
        AS orders_with_agreeing_scores,
    SUM(CASE WHEN distinct_scores > 1 THEN 1 ELSE 0 END)
        AS orders_with_conflicting_scores
FROM repeated_orders;




SELECT
    SUM(CASE
        WHEN NULLIF(TRIM(review_timestamp), '') IS NULL
        THEN 1 ELSE 0
    END) AS missing_response_timestamps,
    SUM(CASE
        WHEN NULLIF(TRIM(review_timestamp), '') IS NOT NULL
         AND TRIM(review_timestamp) NOT REGEXP
             '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
        THEN 1 ELSE 0
    END) AS unexpected_timestamp_format
FROM raw_reviews;


