import json
import logging
from datetime import UTC, datetime
from typing import override

# Attributes every LogRecord has; anything else came from `extra=`. Uvicorn adds
# `color_message`, a copy of the message with terminal colours.
_RECORD_FIELDS = frozenset(vars(logging.makeLogRecord({}))) | {
    "message",
    "asctime",
    "color_message",
}


class JSONFormatter(logging.Formatter):
    """Formats each record as one JSON object per line, with `extra=` fields as keys."""

    @override
    def format(self, record: logging.LogRecord) -> str:
        entry: dict[str, object] = {
            "time": datetime.fromtimestamp(record.created, UTC).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "msg": record.getMessage(),
        }
        entry |= {k: v for k, v in vars(record).items() if k not in _RECORD_FIELDS}
        if record.exc_info:
            entry["exc"] = self.formatException(record.exc_info)
        return json.dumps(entry, default=str)


def configure_logging(level: str) -> None:
    """Send every log record, uvicorn's included, to stderr as JSON lines."""
    handler = logging.StreamHandler()
    handler.setFormatter(JSONFormatter())
    logging.basicConfig(level=level, handlers=[handler], force=True)
    for name in ("uvicorn", "uvicorn.error", "uvicorn.access"):
        uvicorn_logger = logging.getLogger(name)
        uvicorn_logger.handlers.clear()
        uvicorn_logger.propagate = True
