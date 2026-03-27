# Multi-Touch Revenue Attribution Model

A SQL-first marketing attribution project built in PostgreSQL, modelling how revenue credit is distributed across marketing channels using four attribution methodologies.

📊 **[Live Tableau Dashboard](https://public.tableau.com/app/profile/aditya.singh7740/viz/Multi-TouchRevenueAttribution/Dashboard1)**

---

## The Business Problem

When a customer makes a purchase, they typically interact with multiple marketing channels before converting. 

For example, discovering a product via Google, seeing a retargeting ad on Instagram, then converting through an email discount. 

The question is: **which channel deserves credit for the sale? and which channel should be invested in more?**

This project implements four industry-standard attribution models to answer that question, and visualises how the answer changes depending on the model used.

---

## Attribution Models

| Model | Description |
|---|---|
| **First Touch** | 100% of credit goes to the first channel the customer interacted with |
| **Last Touch** | 100% of credit goes to the final channel before purchase |
| **Linear** | Credit is split equally across all touchpoints in the journey |
| **Time Decay** | More credit is given to touchpoints closer to the purchase date |

---

## Key Finding

Instagram receives significantly more credit under last-touch than first-touch, suggesting it plays a stronger role in **closing conversions** than initiating them. Google drives the most first-touch revenue, indicating it is the primary **discovery channel**. A marketing team could use these insights to allocate budget more effectively across the funnel.

---

## Tech Stack

- **PostgreSQL** (hosted on Supabase) — data storage and all attribution logic
- **Python** — synthetic dataset generation
- **SQL** — window functions, CTEs, self-joins, exponential decay calculations
- **Tableau Public** — interactive dashboard

---

## Project Structure

```
revenue-attribution-model/
├── dataset_generation.py        # Generates 1,000 synthetic customer journeys
├── 00_create_table.sql          # Table schema
├── 01_journeys.sql              # Cleans and joins touchpoints to purchases
├── 02_first_last_touch.sql      # First-touch and last-touch attribution
├── 03_linear_attribution.sql    # Linear (equal split) attribution
├── 04_time_decay.sql            # Time-decay weighted attribution
├── 05_comparison.sql            # All 4 models side by side
└── README.md
```

---

## SQL Techniques Used

- **CTEs (Common Table Expressions)** — breaking complex logic into readable steps
- **Window functions** — `ROW_NUMBER()`, `COUNT()`, `SUM()` with `PARTITION BY`
- **Self-joins** — matching touchpoints back to purchase events per customer
- **Exponential decay formula** — `EXP(-0.1 * days_before_purchase)` to weight recency
- **CASE WHEN logic** — selectively attributing revenue per model

---

## Dataset

Synthetic data generated via Python (`dataset_generation.py`) simulating 1,000 customers across 5 marketing channels:

- Instagram
- Google
- Facebook
- Email
- Organic

Each customer has 1–5 touchpoints before purchase, with 40% of customers converting. Purchase values range from $20–$200.

---

## Dashboard

The Tableau Public dashboard includes:
- **Grouped bar chart** — revenue by channel across all 4 attribution models
- **Heatmap** — colour-coded comparison making high/low attribution immediately visible
- **Insight annotation** — key business finding surfaced from the data

👉 [View the live dashboard here](https://public.tableau.com/app/profile/aditya.singh7740/viz/Multi-TouchRevenueAttribution/Dashboard1)
