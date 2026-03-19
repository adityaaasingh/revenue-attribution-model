-- View all touchpoints for customers who made a purchase
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
)

SELECT * FROM touchpoints
ORDER BY customer_id, touch_date
LIMIT 50;