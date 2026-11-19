# app

The service: settings, JSON logging, and HTTP routes. `main.create_app` is the only place that reads settings and wires routers.

## Depends on

Nothing in this repo.

## Used by

- `tests`, through `create_app`.
- uvicorn, through `just dev` and `deploy/Dockerfile`.

## Decisions

- The import package is always `app`, whatever the project is called. The project name lives only in `pyproject.toml` and the matching root entry in `uv.lock`: to rename the project, change `name` and run `uv lock`.
- Every log line, uvicorn's included, is one JSON object on stderr (`log.configure_logging`). Add context with `extra=`.
