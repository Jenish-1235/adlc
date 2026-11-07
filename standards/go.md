# Go

Baseline: Go 1.27. Run `go fix ./...` after every toolchain upgrade.

## Modern Go

- Use `wg.Go(f)`, not `Add`/`Done`. Use `errors.AsType[T]`, not `errors.As`. Use `new(expr)`, not `ptr()` helpers.
- Reach for the standard library before a dependency: `net/http` routing, `log/slog`, `uuid`, `encoding/json/v2`, `slices`, `maps`, `testing/synctest`.
- Track dev tools with `go get -tool`, not `tools.go`.

## Naming

- Name packages for what they provide. Never `util`, `common`, `helpers`, `base`, `types`, or `models`.
- Don't repeat the package name: `order.Service`, not `order.OrderService`.
- No `Get` prefix: `u.Email()`, not `u.GetEmail()`.
- Initialisms keep one case: `userID`, `HTTPClient`.
- Receivers are one or two letters, the same on every method.
- Error variables are `ErrX` and error types are `XError`. Error strings are lowercase with no trailing punctuation.

## Packages

- Non-`main` code lives under `internal/`. `main` loads config, wires dependencies, and calls `run(ctx) error`. Only `main` exits.
- Group by cohesion. If two packages are always imported together, merge them.
- No `init()` and no mutable package-level variables. Pass dependencies explicitly.
- Make zero values useful. Add options only when several real optional settings exist.

## Interfaces

- Define an interface in the package that uses it, with only the methods it calls.

  ```go
  // Bad: package postgres
  type UserRepository interface { /* every method */ }

  // Good: package application
  type userStore interface {
      ByID(context.Context, domain.UserID) (domain.User, error)
  }
  ```

- Accept interfaces, return concrete types.
- No interface until there are two implementations, an I/O test seam, or an import cycle.
- Never add an interface only to mock. Test with the real implementation, a fake, or `httptest`.
- Use generics only when two or more types use the code today.

## Errors

- Wrap with the action, not "failed to": `fmt.Errorf("load order %s: %w", id, err)`.
- Handle each error once: log it or return it, never both.
- Translate errors at layer boundaries. Infrastructure maps `sql.ErrNoRows` to `domain.ErrNotFound`.
- Compare with `errors.Is` or `errors.AsType`, never strings or `==`.
- No in-band errors (`-1`, `""`, `nil, nil`). Return `(T, bool)` or an error.
- No `panic` outside startup and tests.

## Concurrency

- `ctx context.Context` is the first parameter of anything that blocks or does I/O. Never store it in a struct.
- Every goroutine has an owner and an exit: `wg.Go` or `errgroup.WithContext`. No fire-and-forget `go f()`.
- Prefer synchronous APIs. Channels are unbuffered or size one. Only the sender closes a channel.
- `main` uses `signal.NotifyContext`. Workers return when `ctx.Done()` fires.

## Testing

- Use table-driven tests only when cases share logic. Failures read `Func(in) = got, want want`. Diff structs with `cmp.Diff`.
- Use `t.Context()`, `t.Setenv()`, `b.Loop()`, and `testing/synctest` for time and concurrency.
- Test adapters against real dependencies: a database in a container, `httptest`. Run tests with `-race`.

## Logging

- Inject `*slog.Logger`, never a global. Use the `…Context` methods with constant messages.
- Log at the edges (handlers, consumers, `main`), never in `domain`.

## Architecture

### DDD template

| Package | May import |
|---|---|
| `internal/domain` | Standard library only |
| `internal/application` | `domain` |
| `internal/infrastructure` | `domain`; satisfies `application` interfaces without importing it |
| `internal/interfaces/http` | `application`, `domain` |
| `cmd/api` | Everything; the only place that wires |

Keep SQL, JSON tags, HTTP status codes, and SDK types out of `domain` and `application`.

### Event-driven template

| Package | Role | May import |
|---|---|---|
| `internal/events` | Event data types | Standard library only |
| `internal/handlers` | Business logic; defines its own `publisher` interface | `events` |
| `internal/outbox` | Stores events in the same transaction as the state change | `events` |
| `internal/producers` | Drains the outbox to the broker | `events`, `outbox` |
| `internal/consumers` | Broker adapters that call handlers | `events`, `handlers` |
| `cmd/api`, `cmd/worker` | Wiring | Everything |

Handlers never import consumers, producers, or the broker SDK.

## Sources

- [Go 1.27 release notes](https://go.dev/doc/go1.27), [Go 1.26](https://go.dev/doc/go1.26), [Go 1.25](https://go.dev/doc/go1.25)
- [Go Code Review Comments](https://go.dev/wiki/CodeReviewComments), [Effective Go](https://go.dev/doc/effective_go), [Module layout](https://go.dev/doc/modules/layout)
- [Google Go Style: Decisions](https://google.github.io/styleguide/go/decisions), [Best Practices](https://google.github.io/styleguide/go/best-practices)
- [Uber Go Style Guide](https://github.com/uber-go/guide/blob/master/style.md), [Go Proverbs](https://go-proverbs.github.io/)
