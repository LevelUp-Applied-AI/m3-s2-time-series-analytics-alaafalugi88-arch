WITH monthly AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price) AS revenue,
        COUNT(DISTINCT o.order_id) AS orders
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'cancelled'
    GROUP BY month
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_revenue,
    (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) AS revenue_growth,
    orders,
    LAG(orders) OVER (ORDER BY month) AS prev_orders,
    (orders - LAG(orders) OVER (ORDER BY month)) / LAG(orders) OVER (ORDER BY month) AS order_growth
FROM monthly
ORDER BY month;