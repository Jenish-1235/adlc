# Python

Baseline: Python 3.13, managed with uv. Lint and format with Ruff; type-check with mypy `--strict`.

## Tooling

- uv owns the interpreter, the virtualenv, and `uv.lock`: `uv add`, `uv add --dev`, `uv remove`. Commit `uv.lock`. Never `pip install` into a project.
- Run tools with `uv run --locked`, so a stale lock fails instead of silently changing.
- Use the `src/` layout. Tests import the installed package, never the working tree.
- No `# noqa`, `# type: ignore`, or `# pyright: ignore`. Fix the code, or change the rule in `pyproject.toml` with a reason.

## Types

- Annotate every parameter and return type. Let locals infer.
- Use builtin generics and `|`: `list[str]`, `str | None`. Never `List`, `Optional`, or `Union`.
- No `Any` and no `cast()`. Narrow `object` with `isinstance`, or validate untrusted data with a Pydantic model.

  ```python
  order = cast(Order, json.loads(body))  # Bad
  order = Order.model_validate_json(body)  # Good
  ```

- Model closed sets with `Literal` or `StrEnum`. Branch with `match` and end with `assert_never`.
- Use type parameter syntax: `def first[T](xs: Sequence[T]) -> T`, `type UserID = int`. Use generics only when two or more types use the code today.
- Pydantic models only at boundaries: HTTP bodies, settings, external APIs. Internal values are `@dataclass(frozen=True, slots=True)`.
- Accept `collections.abc` types (`Sequence`, `Mapping`, `Iterable`), return concrete ones.
- Define a `Protocol` in the module that uses it, with only the methods it calls. No `ABC` with one implementation.
- Mark every overriding method `@override`.

## Code

- Use functions and modules for stateless logic. Classes only for state with behaviour, exceptions, and data.
- No mutable default arguments. No module-level state besides loggers and routers; pass dependencies in.
- Use `pathlib.Path`, not `os.path`. Datetimes are timezone-aware: `datetime.now(UTC)`.
- Open every resource in a `with` block.
- Never `print` outside scripts. Use logging.

## Errors

- Name exceptions `XError` and subclass `Exception` or a domain base. Raise specific ones, never bare `Exception`.
- Catch the narrowest type you can handle. Never bare `except:`, and never `except Exception: pass`.
- Chain when you translate: `raise NotFoundError(order_id) from err`.
- Return `T | None` only when absence is a normal result. Otherwise raise.

## Async

- In `async def`, never block: no `time.sleep`, `requests`, or sync database drivers. Use an async library or `await asyncio.to_thread(f)`.
- Run concurrent work in an `asyncio.TaskGroup`. No fire-and-forget `asyncio.create_task`.
- Set deadlines with `asyncio.timeout()`.

## Naming

- PEP 8: `snake_case` modules, functions, and variables; `PascalCase` classes; `UPPER_CASE` constants; a leading `_` for module-private names.
- Name modules for what they provide. Never `utils`, `common`, `helpers`, `misc`, or `base`.
- Never shadow builtins or standard library modules: no `id` parameter or `logging.py` module.

## Imports

- Import absolutely from the package root: `from app.orders import service`. No relative imports and no `import *`.
- Keep `__init__.py` empty. No re-exports.

## Testing

- pytest with plain `assert`. Prefer fixtures to setup methods; use `monkeypatch.setenv` for environment and `tmp_path` for files.
- Use `pytest.mark.parametrize` only when cases share logic.
- Test HTTP through the framework's test client, and swap dependencies through the framework (FastAPI `dependency_overrides`), not `mock.patch`.
- Test adapters against real dependencies, such as a database in a container.
- Warnings are errors: `filterwarnings = ["error"]`.

## Logging

- One `logger = logging.getLogger(__name__)` per module. Configure handlers once, at startup.
- Constant messages with context in `extra`: `logger.info("order paid", extra={"order_id": order.id})`. No f-strings in log calls.
- Log at the edges (endpoints, consumers, startup), never in business rules. Use `logger.exception` only where you handle the error.

## Architecture

### FastAPI template

| Module | Role | May import |
|---|---|---|
| `app/<feature>/schemas.py` | Request and response bodies | Pydantic |
| `app/<feature>/models.py` | Database tables | SQLAlchemy, `app.db` |
| `app/<feature>/service.py` | Business rules and use cases; raises domain errors | `models`, other services; never `fastapi` |
| `app/<feature>/router.py` | HTTP routes | `service`, `schemas`, `app.db`, `app.settings` |
| `app/main.py` | Reads settings, wires routers, error handlers, and the lifespan | Everything |

Services never raise `HTTPException` or return schemas. Routers never touch models directly.

## Sources

- [What's New in Python 3.13](https://docs.python.org/3/whatsnew/3.13.html), [Python 3.12](https://docs.python.org/3/whatsnew/3.12.html), [PEP 695](https://peps.python.org/pep-0695/)
- [PEP 8](https://peps.python.org/pep-0008/), [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [Typing best practices](https://typing.python.org/en/latest/reference/best_practices.html), [mypy command line](https://mypy.readthedocs.io/en/stable/command_line.html)
- [uv projects](https://docs.astral.sh/uv/concepts/projects/), [uv with Docker](https://docs.astral.sh/uv/guides/integration/docker/), [uv with FastAPI](https://docs.astral.sh/uv/guides/integration/fastapi/), [Ruff rules](https://docs.astral.sh/ruff/rules/)
- [asyncio tasks](https://docs.python.org/3/library/asyncio-task.html), [Logging HOWTO](https://docs.python.org/3/howto/logging.html)
- [pytest good practices](https://docs.pytest.org/en/stable/explanation/goodpractices.html)
- FastAPI: [Bigger applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/), [Dependencies](https://fastapi.tiangolo.com/tutorial/dependencies/), [Settings](https://fastapi.tiangolo.com/advanced/settings/), [Lifespan events](https://fastapi.tiangolo.com/advanced/events/), [Handling errors](https://fastapi.tiangolo.com/tutorial/handling-errors/), [Testing](https://fastapi.tiangolo.com/tutorial/testing/)
- [SQLAlchemy asyncio](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html), [Pydantic settings](https://docs.pydantic.dev/latest/concepts/pydantic_settings/)
