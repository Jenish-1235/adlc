# Testing and linting

- Run the `test` and `lint` recipes before every commit. Fix failures before committing.
- Every code change ships with tests. For a bug fix, write a failing test first, then fix it.
- Never add inline suppressions (`eslint-disable`, `# noqa`, `@ts-ignore`). Fix the underlying issue.
- Lint and format fixes outside your change go in their own `style:` commit.
