from fastapi import FastAPI

from app import health
from app.log import configure_logging
from app.settings import Settings


def create_app() -> FastAPI:
    """Build the app: the only place that reads settings and wires routers.

    Servers load it with `uvicorn --factory app.main:create_app`.
    """
    settings = Settings()
    configure_logging(settings.log_level)
    app = FastAPI()
    app.include_router(health.router)
    return app
