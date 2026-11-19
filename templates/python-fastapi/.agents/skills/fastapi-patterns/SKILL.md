---
name: fastapi-patterns
description: Apply this FastAPI service's patterns, including feature routers, schemas versus database models, dependency injection with Annotated, async database sessions, and domain errors mapped to HTTP. Use when adding an endpoint, a feature, a table, a setting, or error handling.
---

# FastAPI patterns

Follow `.adlc/standards/python.md`, including its module table. This skill shows how to apply it.

## Where code goes

| If the code… | It goes in |
|---|---|
| reads settings, wires routers, error handlers, and the lifespan | `src/app/main.py` (`create_app`) |
| declares a feature's HTTP routes | `src/app/<feature>/router.py` |
| defines request and response bodies | `src/app/<feature>/schemas.py` |
| defines database tables | `src/app/<feature>/models.py` |
| is a business rule or use case | `src/app/<feature>/service.py` |
| opens database sessions | `src/app/db.py` |

A feature is a package: an empty `__init__.py`, a `README.md`, and a `CHANGELOG.md`.

## Routers

One `APIRouter` per feature, included in `create_app`. Endpoints stay thin: take validated input, call the service, return a schema.

```python
router = APIRouter(prefix="/orders", tags=["orders"])


@router.post("", status_code=201)
async def create_order(body: OrderCreate, session: SessionDep) -> OrderOut:
    order = await service.create_order(session, body.item, body.quantity)
    return OrderOut.model_validate(order)
```

The return annotation is the response model: FastAPI validates and filters the output with it.

## Schemas versus models

- **Schemas** (`schemas.py`) are Pydantic models for the API contract. Inputs forbid unknown fields; outputs read ORM objects with `from_attributes`.
- **Models** (`models.py`) are SQLAlchemy tables. A model never goes out as a response body, so changing a table never changes the API by accident.

```python
class OrderCreate(BaseModel):
    model_config = ConfigDict(extra="forbid")

    item: str = Field(min_length=1, max_length=200)
    quantity: int = Field(gt=0)


class OrderOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    item: str
    quantity: int
```

```python
class Order(Base):
    __tablename__ = "orders"

    id: Mapped[int] = mapped_column(primary_key=True)
    item: Mapped[str] = mapped_column(String(200))
    quantity: Mapped[int]
```

## Dependency injection

- Declare each dependency once, as an `Annotated` alias next to what it provides, and use the alias in endpoints.
- Dependencies that `yield` clean up after the response. Use them for resources like sessions, never for business logic.
- Tests swap dependencies with `app.dependency_overrides`, never `mock.patch`.

When an endpoint needs settings, cache them behind a dependency and make `create_app` call `get_settings()` too:

```python
@cache
def get_settings() -> Settings:
    return Settings()


SettingsDep = Annotated[Settings, Depends(get_settings)]
```

## Async database access

Use SQLAlchemy's asyncio extension with asyncpg (`uv add "sqlalchemy[asyncio]" asyncpg`; a new runtime dependency needs approval). The engine lives as long as the app, created in the lifespan. Each request gets one session in one transaction, committed when the endpoint returns and rolled back if it raises.

```python
# src/app/db.py
class State(TypedDict):
    sessions: async_sessionmaker[AsyncSession]


@asynccontextmanager
async def lifespan(_: FastAPI) -> AsyncIterator[State]:
    engine = create_async_engine(get_settings().database_url)
    yield {"sessions": async_sessionmaker(engine, expire_on_commit=False)}
    await engine.dispose()


async def session(request: Request) -> AsyncIterator[AsyncSession]:
    sessions: async_sessionmaker[AsyncSession] = request.state.sessions
    async with sessions() as s, s.begin():
        yield s


SessionDep = Annotated[AsyncSession, Depends(session)]
```

- Pass `lifespan=lifespan` to `FastAPI()` in `create_app`. Add `database_url: str` to `Settings`, and for local work put `DATABASE_URL=postgresql+asyncpg://app:app@localhost:5432/app` in `.env` (match `DB_PORT` from `just up`).
- Services take the session as their first parameter. They `flush()` when they need generated IDs; the dependency commits.
- Load relationships explicitly with `selectinload`. Lazy loading fails in async code.
- In `async def`, await every I/O call. If a library only has a blocking API, make the endpoint a plain `def` (FastAPI runs it in a thread pool) or call it with `await asyncio.to_thread(...)`.
- Change the schema with migrations (the `write-migration` skill), never `metadata.create_all` outside tests.

## Error handling

- Services raise domain errors, never `HTTPException`. Name them `XError`.

  ```python
  class OrderNotFoundError(Exception):
      def __init__(self, order_id: int) -> None:
          super().__init__(f"order {order_id} not found")
  ```

- `create_app` maps each domain error to a status code once:

  ```python
  @app.exception_handler(OrderNotFoundError)
  async def not_found(_: Request, exc: OrderNotFoundError) -> JSONResponse:
      return JSONResponse({"detail": str(exc)}, status_code=404)
  ```

- Let unexpected exceptions propagate. They become a 500, and uvicorn logs the traceback. No `except Exception` in endpoints or services.
- Request validation is FastAPI's 422. Don't re-check in services what the schema already guarantees.

## Tests

- Test endpoints with `TestClient(create_app())` as a context manager, so the lifespan runs.
- Test services against a real Postgres started with `just up`, not a mocked session.
- Swap settings or a session with `app.dependency_overrides[get_settings] = lambda: Settings(...)`.

## Add a feature

1. Write the schemas and a failing endpoint test.
2. Add the model and its migration.
3. Add the service, raising domain errors, with tests against the database.
4. Add the router, include it in `create_app`, and map any new domain error there.
5. Write the feature's `README.md` and `CHANGELOG.md` with the `update-package-docs` skill.
