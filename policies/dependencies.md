# Dependencies

- {{ask: Which package manager does the team use for each language, e.g. pnpm for JavaScript, uv for Python? Replace this line with one "Use <manager> for <language>." line per language.}}
- If a project's lockfile shows a different package manager, use that one. Never switch.
- Always commit lockfiles. Change them only through the package manager, never by hand.
- Before adding a dependency, confirm it:
  - can't be done in a few lines or with the standard library
  - is actively maintained, with a release in the last year
  - is widely used
  - has a permissive license (MIT, Apache-2.0, BSD)
  - has no known vulnerabilities (check with the manager's audit command or [osv.dev](https://osv.dev))
- When asking approval for a dependency, show the results of these checks.
- Docker base images are dependencies too: official or verified publishers only, pinned to a version (never `:latest`), and the slim or alpine variant when one exists.
