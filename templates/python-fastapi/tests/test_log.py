import json
import logging
import sys

from app.log import JSONFormatter


def test_json_formatter_adds_extra_fields() -> None:
    record = logging.makeLogRecord(
        {"name": "app.orders", "levelname": "INFO", "msg": "order paid", "order_id": 42}
    )

    line = json.loads(JSONFormatter().format(record))

    assert line["logger"] == "app.orders"
    assert line["level"] == "INFO"
    assert line["msg"] == "order paid"
    assert line["order_id"] == 42


def test_json_formatter_adds_exception() -> None:
    try:
        raise ValueError("boom")
    except ValueError:
        record = logging.makeLogRecord({"msg": "failed", "exc_info": sys.exc_info()})

    line = json.loads(JSONFormatter().format(record))

    assert "ValueError: boom" in line["exc"]
