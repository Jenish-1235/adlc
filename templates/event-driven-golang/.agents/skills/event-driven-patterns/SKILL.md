---
name: event-driven-patterns
description: Apply event-driven patterns in this Go service, including event design, the transactional outbox, idempotent consumers, retries, and dead-lettering. Use when adding or changing an event, handler, producer, or consumer.
---

# Event-driven patterns

Follow `.adlc/standards/go.md`, including its package table. This skill shows how to apply the patterns.

## Events

- Name events as past-tense facts: `OrderSubmitted`, not `SubmitOrder`.
- Every event travels in an envelope:

  ```go
  type Envelope struct {
  	ID         string
  	Type       string
  	Version    int
  	OccurredAt time.Time
  	Payload    json.RawMessage
  }
  ```

- The payload carries what consumers need, plus IDs for everything else. Never the whole aggregate.
- Change events additively only. A breaking change is a new version, and producers publish both versions until every consumer has moved.

## Publishing: the transactional outbox

Never publish to the broker during a request. Write the event to the outbox in the same transaction as the state change:

```go
tx, err := db.BeginTx(ctx, nil)
if err != nil {
	return err
}
defer tx.Rollback()
if err := saveOrder(ctx, tx, order); err != nil {
	return err
}
if err := outbox.Add(ctx, tx, event); err != nil {
	return err
}
return tx.Commit()
```

Producers read unsent outbox rows, publish them, then mark them sent. Delivery is at least once.

## Consuming

- Every handler must be safe to run twice. Record the event ID in the same transaction as the handler's changes, and skip IDs already recorded.
- Acknowledge a message only after the handler's transaction commits.
- Order is guaranteed only per partition key. Use the aggregate ID as the key, and never assume order across aggregates.
- Retry transient errors with backoff a fixed number of times, then dead-letter the message with its error. Dead-letter invalid messages immediately.
- Handlers hold business logic only. Consumers own decoding, acknowledging, retrying, and dead-lettering.

## Avoid

- Events that nothing consumes.
- Event sourcing, sagas, and CQRS, until a real requirement demands them.

## Add an event

1. Define the event type in `internal/events`.
2. Write it to the outbox where the state change happens, with a test.
3. Handle it in `internal/handlers`, with a test that delivers it twice.
4. Route it in `internal/consumers`.
5. Wire it in `cmd/worker`.
