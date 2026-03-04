from flask import Flask, Response
from prometheus_client import Counter, generate_latest
import logging
import random
import time

app = Flask(__name__)

# Metrics
REQUEST_COUNT = Counter("app_requests_total", "Total number of requests")

# Logging setup
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

@app.route("/")
def home():
    REQUEST_COUNT.inc()
    logging.info("Home page accessed")
    # Randomly simulate error
    if random.randint(1, 10) > 8:
        logging.error("Simulated error occurred!")
    return "Hello from monitoring lab!"

@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype="text/plain")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)