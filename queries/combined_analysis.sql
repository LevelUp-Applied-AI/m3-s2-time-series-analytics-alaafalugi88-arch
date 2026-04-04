WITH monthly_segment AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        c.segment,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.status != 'cancelled'
    GROUP BY month, c.segment
)
SELECT
    month,
    segment,
    revenue,
    SUM(revenue) OVER (PARTITION BY segment ORDER BY month) AS running_total,
    LAG(revenue) OVER (PARTITION BY segment ORDER BY month) AS prev_revenue,
    (revenue - LAG(revenue) OVER (PARTITION BY segment ORDER BY month)) / LAG(revenue) OVER (PARTITION BY segment ORDER BY month) AS growth_rate
FROM monthly_segment
ORDER BY month, segment;