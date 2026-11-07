---
name: nextjs-patterns
description: Apply this Next.js app's patterns, including the data access layer, validated Server Actions, cache tags, and small client components. Use when adding a page, route, form, mutation, or data fetch.
---

# Next.js patterns

Follow `.adlc/standards/nextjs.md`, `react.md`, and `typescript.md`. This skill shows how to apply them.

## Data access layer

All reads go through `src/lib/data/`. Each function checks access and returns only the fields the UI needs.

```ts
import "server-only"

export async function getOrder(id: string) {
  const user = await requireUser()
  const order = await findOrder(id, user.id)
  if (!order) notFound()
  return { id: order.id, status: order.status, total: order.total }
}
```

## Caching

- Cache only data that isn't per user, with `'use cache'`, a `cacheLife`, and a `cacheTag`.
- Tags are `<entity>` for lists and `<entity>:<id>` for one record, e.g. `orders` and `order:42`.

## Server Actions

Actions live in `src/lib/actions/`. Each one checks the user, validates input, writes, then invalidates its tags.

```ts
"use server"

type State = { status: "idle" | "ok" } | { status: "error"; error: string }

const Input = z.object({ id: z.string(), note: z.string().max(500) })

export async function addNoteAction(_: State, form: FormData): Promise<State> {
  const user = await requireUser()
  const input = Input.safeParse(Object.fromEntries(form))
  if (!input.success) return { status: "error", error: "Invalid note" }
  await addNote(user.id, input.data)
  updateTag(`order:${input.data.id}`)
  return { status: "ok" }
}
```

## Client components

The page fetches on the server and passes minimal props to a small `'use client'` component that owns the interaction. Forms use `useActionState` with the action.

## Add a route

1. Add the data function in `src/lib/data/`, with a test.
2. Add `page.tsx` as a Server Component that calls it. Wrap slow parts in `<Suspense>`.
3. Put interactive parts in `app/<route>/_components/` as client components.
4. Add mutations as Server Actions in `src/lib/actions/`, with a test.
