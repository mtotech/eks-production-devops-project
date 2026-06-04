from flask import Flask
from prometheus_client import Counter, generate_latest

app = Flask(__name__)

REQUESTS = Counter(
    "request_count",
    "Total Request Count"
)

@app.route("/")
def home():

    REQUESTS.inc()

    return {
        "Application": "Production Flask App",
        "Platform": "Amazon EKS",
        "Status": "Running"
    }

@app.route("/health")
def health():

    return {
        "status": "healthy"
    }

@app.route("/metrics")
def metrics():

    return generate_latest()

if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )
