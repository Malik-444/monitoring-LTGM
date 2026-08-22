from app import app


def test_home():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200


def test_metrics():
    client = app.test_client()

    response = client.get("/metrics")

    assert response.status_code == 200
    assert b"app_requests_total" in response.data
