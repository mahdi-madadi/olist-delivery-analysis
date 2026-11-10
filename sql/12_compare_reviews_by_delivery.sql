SELECT
    CASE WHEN is_late = 1 THEN 'Late' ELSE 'On time' END
        AS delivery_status,
    COUNT(*) AS eligible_orders,
    COUNT(review_score) AS reviewed_orders,
    ROUND(100.0 * COUNT(review_score) / COUNT(*), 2)
        AS review_coverage_pct,
    ROUND(AVG(review_score), 2) AS average_review_score,
    ROUND(
        100.0 * SUM(CASE WHEN review_score IN (1, 2) THEN 1 ELSE 0 END)
        / NULLIF(COUNT(review_score), 0),
        2
    ) AS low_score_pct
FROM delivery_review_metrics
GROUP BY is_late
ORDER BY is_late;