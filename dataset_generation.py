import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

random.seed(42)
channels = ['Instagram', 'Google', 'Email', 'Facebook', 'Organic']
customers = 1000
rows = []

for customer_id in range(1, customers + 1):
    # Each customer has 1-5 touchpoints
    num_touches = random.randint(1, 5)
    start_date = datetime(2024, 1, 1) + timedelta(days=random.randint(0, 180))
    
    for i in range(num_touches):
        touch_date = start_date + timedelta(days=i * random.randint(1, 5))
        rows.append({
            'customer_id': customer_id,
            'channel': random.choice(channels),
            'event_type': 'touchpoint',
            'timestamp': touch_date,
            'revenue': 0
        })
    
    # 40% of customers make a purchase
    if random.random() < 0.4:
        purchase_date = touch_date + timedelta(days=random.randint(0, 3))
        rows.append({
            'customer_id': customer_id,
            'channel': 'direct',
            'event_type': 'purchase',
            'timestamp': purchase_date,
            'revenue': round(random.uniform(20, 200), 2)
        })

df = pd.DataFrame(rows)
df.to_csv('customer_journeys.csv', index=False)
print(df.head(20))