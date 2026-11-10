WITH delay_bands AS (
    SELECT
        review_score,
        CASE
            WHEN days_vs_estimate <= 0 THEN 'On time'
            WHEN days_vs_estimate <= 3 THEN '1–3 days late'
            WHEN days_vs_estimate <= 7 THEN '4–7 days late'
            ELSE '8+ days late'
        END AS delay_band
    FROM delivery_review_metrics
)
SELECT
    delay_band,
    COUNT(*) AS eligible_orders,
    COUNT(review_score) AS reviewed_orders,
    ROUND(AVG(review_score), 2) AS average_review_score,
    ROUND(
        100.0 * SUM(CASE WHEN review_score IN (1, 2) THEN 1 ELSE 0 END)
        / NULLIF(COUNT(review_score), 0),
        2
    ) AS low_score_pct
FROM delay_bands
GROUP BY delay_band
ORDER BY FIELD(
    delay_band, 'On time', '1–3 days late', '4–7 days late', '8+ days late'
);