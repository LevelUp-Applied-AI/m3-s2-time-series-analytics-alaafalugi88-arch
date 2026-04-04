WITH first_purchase AS (
    SELECT
        o.customer_id,
        MIN(o.order_date) AS first_order_date
    FROM orders o
    WHERE o.status != 'cancelled'
    GROUP BY o.customer_id
),
cohort_data AS (
    SELECT
        o.customer_id,
        DATE_TRUNC('month', fp.first_order_date) AS cohort_month,
        o.order_date
    FROM orders o
    JOIN first_purchase fp ON o.customer_id = fp.customer_id
    WHERE o.status != 'cancelled'
)
SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS cohort_size
FROM cohort_data
GROUP BY cohort_month
ORDER BY cohort_month;