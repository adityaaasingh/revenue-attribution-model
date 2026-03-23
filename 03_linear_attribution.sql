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
        p.revenue,
        COUNT(*) OVER (PARTITION BY cj.customer_id) AS total_touches
    FROM customer_journeys cj
    INNER JOIN purchases p ON cj.customer_id = p.customer_id
    WHERE cj.event_type = 'touchpoint'
    AND cj.timestamp <= p.purchase_date
)

SELECT
    channel,
    ROUND(SUM(revenue / total_touches), 2) AS linear_attributed_revenue
FROM touchpoints
GROUP BY channel
ORDER BY linear_attributed_revenue DESC;