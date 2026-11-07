# TypeScript

Baseline: TypeScript 7 with `strict`, `noUncheckedIndexedAccess`, `verbatimModuleSyntax`, and `erasableSyntaxOnly`.

## Types

- Never use `any`. Use `unknown` and narrow it.
- No `as` casts except `as const`. Validate untrusted data with a schema.

  ```ts
  const user = (await res.json()) as User   // Bad
  const user = User.parse(await res.json()) // Good
  ```

- No non-null `!`. Narrow the value or throw.
- No `enum`, `const enum`, or `namespace`. Use string-literal unions or `as const` objects.
- Model variants as discriminated unions with an exhaustive `switch`, not optional flags.

  ```ts
  type State = { loading?: boolean; error?: string; data?: T }                // Bad
  type State = { status: "ok"; data: T } | { status: "error"; error: string } // Good
  ```

- Use `satisfies` instead of an annotation when you want to keep literal types.
- Don't annotate what TypeScript infers. Annotate parameters and exported boundaries only.
- Derive types instead of retyping them: `typeof`, `z.infer`, `ComponentProps<"button">`, `Awaited<ReturnType<…>>`.
- No generic parameter that appears only once. Use the concrete type.
- No `Function`, `{}`, or `Object` types.
- No optional props or parameters "just in case". Optional means absence has a meaning.

## Code

- Handle every promise: `await` it, return it, or mark it `void`.
- Treat `catch (e)` as `unknown`. Narrow with `instanceof Error`. Only throw `Error` objects.
- Use functions and modules, not classes, for stateless logic. Classes only for `Error` subclasses or real stateful lifecycles.

## Modules

- Use `import type` for type-only imports.
- Named exports only. Default exports only where a framework requires them.
- No barrel `index.ts` files. Import from the file that defines the thing.
- Use the `@/` alias across folders. Use relative imports only inside a folder.

## Sources

- [TypeScript 7.0](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/), [TypeScript 6.0](https://devblogs.microsoft.com/typescript/announcing-typescript-6-0/)
- [tsconfig reference](https://www.typescriptlang.org/tsconfig/)
- [typescript-eslint shared configs](https://typescript-eslint.io/users/configs)
