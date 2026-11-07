# Next.js

Baseline: Next.js 16.4 (App Router) with `cacheComponents` and `typedRoutes` on. Also follow [react.md](react.md) and [typescript.md](typescript.md).

## Server and client

- Server Components by default. Put `'use client'` only on leaf interactive files, never on a `page` or `layout` to use one hook.
- To nest server UI inside client UI, pass it as `children`. Never import it into the client file.
- Pass minimal, serializable props to Client Components, never whole database rows. Client Components are never `async`.

## Data

- Fetch in Server Components from `src/lib`. Never `fetch` your own Route Handler from the server.
- Never fetch initial data in Client Components. Pass it as props, or pass a promise and read it with `use()`.
- Start independent requests together with `Promise.all`. Wrap request-time data in `<Suspense>` close to where it's used.
- Every `'use cache'` gets a `cacheLife`, plus a `cacheTag` if it will be invalidated.
- Never use `export const dynamic`, `revalidate`, or `fetchCache`.
- Read `cookies()` and `headers()` outside `'use cache'` and pass the values in.

## Mutations

- Server Actions are for mutations only, never for fetching.
- Every Server Action checks authentication, authorization, and input itself, then calls `updateTag`, `revalidateTag`, or `refresh`. `redirect()` comes last, outside `try/catch`.
- Server Actions live in `src/lib`, or are passed down as `*Action` props.

## Security

- Data and secret code imports `'server-only'`. Only `src/lib` reads secrets and the database.
- `NEXT_PUBLIC_` is only for values safe to expose.
- `proxy.ts` only redirects, rewrites, and sets headers. Never rely on it alone for auth.

## Routing

- Type pages with `PageProps<'/route'>` and `LayoutProps`, and `await params`.
- Use `next/link`, `next/image`, `next/font`, and `next/script`. No raw `<a>` for internal routes, no `<img>`.
- Add Route Handlers only for external consumers and webhooks.
- Put route-only components in `app/<route>/_components`. Move them to `src/components` when a second route uses them.
- Place context providers as deep in the tree as possible.

## Architecture (nextjs template)

Imports flow one way: `src/app` → `src/components` → `src/lib`. `src/lib` imports nothing from the app.

## Sources

- [Next.js 16.4](https://nextjs.org/blog/next-16-4), [Next.js 16](https://nextjs.org/blog/next-16)
- [Server and Client Components](https://nextjs.org/docs/app/getting-started/server-and-client-components), [Fetching data](https://nextjs.org/docs/app/getting-started/fetching-data), [Mutating data](https://nextjs.org/docs/app/getting-started/mutating-data)
- [Caching](https://nextjs.org/docs/app/getting-started/caching), [Data security](https://nextjs.org/docs/app/guides/data-security), [Proxy](https://nextjs.org/docs/app/api-reference/file-conventions/proxy)
- [Project structure](https://nextjs.org/docs/app/getting-started/project-structure)
