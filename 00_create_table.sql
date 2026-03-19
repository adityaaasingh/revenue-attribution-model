CREATE TABLE customer_journeys (
    customer_id     INT,
    channel         VARCHAR(50),
    event_type      VARCHAR(50),
    timestamp       TIMESTAMP,
    revenue         DECIMAL(10,2)
);