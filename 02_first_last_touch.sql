WITH purchases AS (
    SELECT
        customer_id,
        timestamp AS purchase_date,
        revenue
    FROM customer_journeys
    WHERE event_type = 'purchase'
),
touchpoints AS (
    SELECT
        cj.customer_id,
        cj.channel,
        cj.timestamp AS touch_date,
        p.revenue
    FROM customer_journeys cj
    INNER JOIN purchases p ON cj.customer_id = p.customer_id
    WHERE cj.event_type = 'touchpoint'
    AND cj.timestamp <= p.purchase_date
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY touch_date ASC)  AS touch_order_asc,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY touch_date DESC) AS touch_order_desc
    FROM touchpoints
)

SELECT
    channel,
    ROUND(SUM(CASE WHEN touch_order_asc = 1  THEN revenue ELSE 0 END), 2) AS first_touch_revenue,
    ROUND(SUM(CASE WHEN touch_order_desc = 1 THEN revenue ELSE 0 END), 2) AS last_touch_revenue
FROM ranked
GROUP BY channel
ORDER BY first_touch_revenue DESC;