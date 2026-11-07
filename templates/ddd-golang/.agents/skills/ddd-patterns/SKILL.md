---
name: ddd-patterns
description: Apply domain-driven design patterns in this Go service, including value objects, aggregates, repositories, use cases, and domain events. Use when adding a feature, changing domain logic, or deciding which layer code belongs in.
---

# DDD patterns

Follow `.adlc/standards/go.md`, including its layer table. This skill shows how to apply the patterns.

## Where code goes

| If the code… | It goes in |
|---|---|
| is a business rule that holds regardless of storage or transport | `internal/domain` |
| coordinates a use case: load, call the domain, save | `internal/application` |
| talks to a database, API, or broker | `internal/infrastructure` |
| translates HTTP into a use case call | `internal/interfaces/http` |

## Value objects

Immutable values validated on construction. Use them for anything with rules: emails, money, IDs.

```go
type Email struct{ value string }

func NewEmail(s string) (Email, error) {
	addr, err := mail.ParseAddress(s)
	if err != nil {
		return Email{}, ErrInvalidEmail
	}
	return Email{addr.Address}, nil
}
```

## Aggregates

- Fields are unexported. State changes only through methods that enforce the rules.
- Change one aggregate per transaction. Reference other aggregates by ID, never by pointer.
- Infrastructure rebuilds an aggregate from storage through an exported `Restore` function that skips creation rules.

```go
func (o *Order) Submit() error {
	if len(o.lines) == 0 {
		return ErrEmptyOrder
	}
	o.status = StatusSubmitted
	return nil
}
```

## Repositories

- One per aggregate, defined as an interface in `application`, with only the methods its use cases call.
- They load and save whole aggregates. No generic repositories, and no query builders leaking out.

## Use cases

One method per use case. Load, call the domain, save. Business rules never live here.

```go
func (s *Service) SubmitOrder(ctx context.Context, id domain.OrderID) error {
	order, err := s.orders.ByID(ctx, id)
	if err != nil {
		return fmt.Errorf("load order %s: %w", id, err)
	}
	if err := order.Submit(); err != nil {
		return err
	}
	return s.orders.Save(ctx, order)
}
```

## Domain events

Record past-tense facts (`OrderSubmitted`) on the aggregate, and publish them after saving. Add one only when something reacts to it.

## Avoid

- Anemic models: if a struct only holds data and the service holds the rules, move the rules into the domain.
- Domain services, unless a rule spans more than one aggregate.
- CQRS, event sourcing, and the specification pattern, until a real requirement demands them.
- Transport or storage types in `domain`. Map them in `interfaces/http` and `infrastructure`.

## Add a feature

1. Change the domain with a failing test first. Domain tests need no fakes.
2. Add the use case in `application`, tested with a fake repository.
3. Implement the repository in `infrastructure`, tested against a real database.
4. Add the handler in `interfaces/http`, tested with `httptest`.
5. Wire it in `cmd/api`.
