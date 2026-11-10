SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_order_ids,
    SUM(
        CASE
            WHEN order_id IS NULL OR TRIM(order_id) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_order_ids,
    SUM(
        CASE
            WHEN customer_id IS NULL OR TRIM(customer_id) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_customer_ids,
    SUM(
        CASE
            WHEN order_id IS NOT NULL
                 AND CHAR_LENGTH(TRIM(order_id)) <> 32
            THEN 1 ELSE 0
        END
    ) AS unexpected_order_id_length
FROM raw_orders;

SELECT
    order_status,
    COUNT(*) AS order_count,
    SUM(
        CASE
            WHEN order_purchase_timestamp IS NULL
                 OR TRIM(order_purchase_timestamp) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_purchase_date,
    SUM(
        CASE
            WHEN order_delivered_customer_date IS NULL
                 OR TRIM(order_delivered_customer_date) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_customer_delivery_date,
    SUM(
        CASE
            WHEN order_estimated_delivery_date IS NULL
                 OR TRIM(order_estimated_delivery_date) = ''
            THEN 1 ELSE 0
        END
    ) AS missing_estimated_delivery_date
FROM raw_orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM raw_orders
WHERE order_status = 'delivered'
  AND NULLIF(
      TRIM(order_delivered_customer_date), ''
  ) IS NULL
ORDER BY order_purchase_timestamp;



WITH date_fields AS (
    SELECT 'purchase' AS date_field,
           order_purchase_timestamp AS date_value
    FROM raw_orders

    UNION ALL

    SELECT 'approval', order_approved_at
    FROM raw_orders

    UNION ALL

    SELECT 'carrier_handover', order_delivered_carrier_date
    FROM raw_orders

    UNION ALL

    SELECT 'customer_delivery', order_delivered_customer_date
    FROM raw_orders

    UNION ALL

    SELECT 'estimated_delivery', order_estimated_delivery_date
    FROM raw_orders
)
SELECT
    date_field,
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN NULLIF(TRIM(date_value), '') IS NULL
            THEN 1 ELSE 0
        END
    ) AS missing_values,
    SUM(
        CASE
            WHEN NULLIF(TRIM(date_value), '') IS NOT NULL
             AND TRIM(date_value) NOT REGEXP
                 '^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}$'
            THEN 1 ELSE 0
        END
    ) AS unexpected_format
FROM date_fields
GROUP BY date_field
ORDER BY date_field;