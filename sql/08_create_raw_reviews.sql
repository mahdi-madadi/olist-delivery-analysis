USE olist_delivery_analysis;

CREATE TABLE raw_reviews (
    review_id VARCHAR(64),
    order_id VARCHAR(64),
    review_score VARCHAR(10),
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date VARCHAR(50),
    review_timestamp VARCHAR(50)
);

SHOW COLUMNS FROM raw_reviews;

SELECT COUNT(*) AS imported_review_rows
FROM raw_reviews;

SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_timestamp
FROM raw_reviews
LIMIT 3;