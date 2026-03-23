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
        EXTRACT(EPOCH FROM (p.purchase_date - cj.timestamp)) / 86400 AS days_before_purchase
    FROM customer_journeys cj
    INNER JOIN purchases p ON cj.customer_id = p.customer_id
    WHERE cj.event_type = 'touchpoint'
    AND cj.timestamp <= p.purchase_date
),
weighted AS (
    SELECT *,
        EXP(-0.1 * days_before_purchase) AS decay_weight,
        SUM(EXP(-0.1 * days_before_purchase)) OVER (PARTITION BY customer_id) AS total_weight
    FROM touchpoints
)

SELECT
    channel,
    ROUND(SUM(revenue * decay_weight / total_weight), 2) AS time_decay_revenue
FROM weighted
GROUP BY channel
ORDER BY time_decay_revenue DESC;