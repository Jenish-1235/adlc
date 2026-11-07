# handlers

Business logic triggered by API calls and events. Writes events through its own `publisher` interface.

## Depends on

- `events`.

## Used by

- `consumers`: call handlers for each message.
- `cmd/api`, `cmd/worker`: wire them.

## Decisions
