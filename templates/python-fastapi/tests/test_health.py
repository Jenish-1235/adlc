from fastapi.testclient import TestClient

from app.main import create_app


def test_healthz() -> None:
    with TestClient(create_app()) as client:
        res = client.get("/healthz")

    assert res.status_code == 200
    assert res.json() == {"status": "ok"}
