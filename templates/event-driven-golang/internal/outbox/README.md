# outbox

Stores events in the same transaction as the state change, and reads unsent ones.

## Depends on

- `events`.

## Used by

- `producers`: drain it.
- `cmd/api`, `cmd/worker`: pass it to handlers as their publisher.

## Decisions
