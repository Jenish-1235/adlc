# React

Baseline: React 19.3 with the React Compiler on. Also follow [typescript.md](typescript.md).

## State and effects

- Compute derived values during render. Never copy them into state.

  ```tsx
  useEffect(() => setFullName(first + " " + last), [first, last]) // Bad
  const fullName = first + " " + last                             // Good
  ```

- Never call `setState` synchronously inside an effect.
- Put event logic (requests, toasts, notifying the parent) in the event handler, not in an effect.
- Use effects only to sync with external systems, and always return a cleanup. Use `useSyncExternalStore` for external stores.
- Reset state when a prop changes with `key={id}`, not with an effect.
- Keep state minimal: store `selectedId`, not a copy of the object. Use one status union, not several booleans.
- Lift shared state to the closest common parent. Never sync two copies with an effect.
- Never fetch app data in `useEffect`. Use server data in Next.js, or TanStack Query in a single-page app.
- Never disable `exhaustive-deps`. Move non-reactive logic into `useEffectEvent`.

## Components

- With the React Compiler on, don't write `useMemo`, `useCallback`, or `memo` by default.
- Keep render pure: no mutation of props, state, or globals, no `Date.now()` or `Math.random()`, no reading `ref.current`.
- Never define a component inside another component. Never call a component as a function.
- Extract a component only when it's reused or has its own state.
- Use stable data IDs as keys. Index keys only for static lists.
- Catch render errors with error boundaries, not `try/catch` around JSX.

## Hooks

- Name a function `useX` only if it calls hooks.
- No lifecycle hooks like `useMount`. No hook that only wraps one `useState`.
- Name hooks after a concrete use: `useOnlineStatus`, not `useData`.

## Data flow

- Pass props first. Two or three levels is fine. Then try passing JSX as `children`.
- Use context only for rarely changing, app-wide values: theme, user, locale.
- Use React 19 APIs: `ref` as a prop (no `forwardRef`), `<Context value>` (no `.Provider`).
- Forms use `<form action={fn}>` with `useActionState`, `useFormStatus`, and `useOptimistic`. No hand-written `isSubmitting` state.

## Architecture (react-vite template)

Imports flow one way: `main.tsx`/`App.tsx` → `components` → `hooks` → `lib`. `lib` imports nothing from the app.

## Sources

- [React 19.3](https://react.dev/blog/2026/09/09/react-19-3), [Rules of React](https://react.dev/reference/rules)
- [You Might Not Need an Effect](https://react.dev/learn/you-might-not-need-an-effect), [Choosing the State Structure](https://react.dev/learn/choosing-the-state-structure)
- [Reusing Logic with Custom Hooks](https://react.dev/learn/reusing-logic-with-custom-hooks), [Passing Data Deeply with Context](https://react.dev/learn/passing-data-deeply-with-context)
- [React Compiler](https://react.dev/learn/react-compiler/introduction), [eslint-plugin-react-hooks](https://react.dev/reference/eslint-plugin-react-hooks)
