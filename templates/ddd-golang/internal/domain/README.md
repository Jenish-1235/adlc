# domain

Business rules: value objects, entities, and aggregates. No storage, transport, or framework code.

## Depends on

Standard library only.

## Used by

- `application`: calls domain methods in use cases.
- `infrastructure`: stores and restores aggregates.
- `interfaces/http`: maps domain errors to responses.

## Decisions
