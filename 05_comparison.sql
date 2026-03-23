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
        p.purchase_date,
        EXTRACT(EPOCH FROM (p.purchase_date - cj.timestamp)) / 86400 AS days_before_purchase,
        COUNT(*) OVER (PARTITION BY cj.customer_id) AS total_touches
    FROM customer_journeys cj
    INNER JOIN purchases p ON cj.customer_id = p.customer_id
    WHERE cj.event_type = 'touchpoint'
    AND cj.timestamp <= p.purchase_date
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY touch_date ASC)  AS touch_order_asc,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY touch_date DESC) AS touch_order_desc,
        EXP(-0.1 * days_before_purchase) AS decay_weight,
        SUM(EXP(-0.1 * days_before_purchase)) OVER (PARTITION BY customer_id) AS total_weight
    FROM touchpoints
)

SELECT
    channel,
    ROUND(SUM(CASE WHEN touch_order_asc  = 1 THEN revenue ELSE 0 END), 2) AS first_touch,
    ROUND(SUM(CASE WHEN touch_order_desc = 1 THEN revenue ELSE 0 END), 2) AS last_touch,
    ROUND(SUM(revenue / total_touches), 2)                                 AS linear,
    ROUND(SUM(revenue * decay_weight / total_weight), 2)                   AS time_decay
FROM ranked
GROUP BY channel
ORDER BY time_decay DESC;