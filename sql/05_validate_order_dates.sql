SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN order_delivered_customer_date
                 < order_purchase_timestamp
            THEN 1 ELSE 0
        END
    ) AS customer_delivery_before_purchase,

    SUM(
        CASE
            WHEN order_delivered_carrier_date
                 < order_purchase_timestamp
            THEN 1 ELSE 0
        END
    ) AS carrier_handover_before_purchase,

    SUM(
        CASE
            WHEN order_delivered_customer_date
                 < order_delivered_carrier_date
            THEN 1 ELSE 0
        END
    ) AS customer_delivery_before_carrier_handover,

    SUM(
        CASE
            WHEN DATE(order_estimated_delivery_date)
                 < DATE(order_purchase_timestamp)
            THEN 1 ELSE 0
        END
    ) AS estimated_delivery_before_purchase
FROM orders_clean;



SELECT
    order_status,
    COUNT(*) AS affected_orders,
    SUM(
        CASE
            WHEN order_delivered_carrier_date
                 < order_purchase_timestamp
            THEN 1 ELSE 0
        END
    ) AS handover_before_purchase,
    SUM(
        CASE
            WHEN order_delivered_customer_date
                 < order_delivered_carrier_date
            THEN 1 ELSE 0
        END
    ) AS delivery_before_handover,
    SUM(
        CASE
            WHEN order_delivered_carrier_date
                 < order_purchase_timestamp
             AND order_delivered_customer_date
                 < order_delivered_carrier_date
            THEN 1 ELSE 0
        END
    ) AS both_issues
FROM orders_clean
WHERE order_delivered_carrier_date < order_purchase_timestamp
   OR order_delivered_customer_date < order_delivered_carrier_date
GROUP BY order_status
ORDER BY affected_orders DESC;