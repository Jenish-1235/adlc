---
name: react-patterns
description: Apply this React single-page app's patterns, including the API client, server state with TanStack Query, URL state, and forms. Use when adding a screen, component, data fetch, or form.
---

# React patterns

Follow `.adlc/standards/react.md` and `typescript.md`. This skill shows how to apply them.

## API client

All requests go through `src/lib/api/`. Each function validates the response with a schema and returns typed data.

```ts
const Order = z.object({ id: z.string(), status: z.enum(["draft", "submitted"]) })

export async function getOrder(id: string) {
  const res = await fetch(`/api/orders/${id}`)
  if (!res.ok) throw new Error(`get order ${id}: ${res.status}`)
  return Order.parse(await res.json())
}
```

## Server state

- Server data lives in TanStack Query, never in `useState`. One hook per resource in `src/hooks/`.
- Query keys are `[entity]` for lists and `[entity, id]` for one record. Invalidate them after mutations.

```ts
export function useOrder(id: string) {
  return useQuery({ queryKey: ["order", id], queryFn: () => getOrder(id) })
}
```

## Client state

- Keep state in the lowest component that needs it.
- Put state that should survive a reload or be shareable (filters, tabs, pages) in the URL.

## Forms

Use `<form action={fn}>` with `useActionState`. Submit through a mutation, then invalidate its query keys.

## Add a screen

1. Add the API function in `src/lib/api/`, with a test.
2. Add the query or mutation hook in `src/hooks/`.
3. Build the screen from existing components in `src/components/`. Add a component only when none fits.
4. Test the screen's behavior, not its implementation.
