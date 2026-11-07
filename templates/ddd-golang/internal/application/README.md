# application

Use cases: load aggregates, call the domain, save. Defines the interfaces it needs, such as repositories.

## Depends on

- `domain`.

## Used by

- `interfaces/http`: calls use cases.
- `cmd/api`: wires implementations in.

## Decisions
