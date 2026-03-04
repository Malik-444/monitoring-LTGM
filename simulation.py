import requests
import random
import time

url = "http://localhost:5000/"

for i in range(100):  # 100 requests
    try:
        r = requests.get(url)
        print(f"{r.status_code} - {r.text}")
        time.sleep(random.uniform(0.05, 0.2))  # simulate bursty traffic
    except Exception as e:
        print(e)