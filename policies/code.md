# Code

Before editing code, read the file in `standards/` for each language you touch, and the `README.md` of each package you touch. Keep package docs current with the `update-package-docs` skill.

## Priority

When rules conflict, the earlier one wins:

1. **Correct:** the tests pass.
2. **Simple:** build only what the current task needs (YAGNI).
3. **Clear:** a reader understands it without explanation.
4. **Idiomatic:** follows the language standard.
5. **SOLID:** applied at real change points and architecture boundaries, never in advance.

## Rules

- Every line must earn its place. If removing it changes nothing, remove it.
- Dependencies flow one way: inward toward the domain, or down toward `lib`. A lower layer never imports a higher one.
- No interface, factory, strategy, or registry with one implementation, unless it sits at an architecture boundary (domain and database, HTTP, or broker).
- No functions that only forward a call or wrap one or two lines.
- No unused parameters, options, config keys, environment variables, or feature flags "for flexibility".
- Validate at system boundaries only. No defensive checks for states the types or callers already rule out.
- Let errors propagate unless you can actually recover. Never swallow them.
- Comments explain why, never what. Never narrate the change.
- No dead code: commented-out blocks, unused imports, debug logs, superseded paths.
- Search the repo for an existing helper before writing a new one.
- Wait for the third repetition before extracting. Prefer duplication over the wrong abstraction. Never share code by adding a boolean parameter.
- No compatibility shims or `new_`/`v2_` names when the only consumer is in this repo. Databases and published APIs still need expand/contract.
- Keep constants as constants unless they vary per environment.
- Build only what was asked: no unrequested retries, caching, metrics, endpoints, or flags.

## Sources

- [YAGNI](https://martinfowler.com/bliki/Yagni.html), [Beck's rules of simple design](https://martinfowler.com/bliki/BeckDesignRules.html)
- [The Clean Architecture: the Dependency Rule](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html), [Solid Relevance](https://blog.cleancoder.com/uncle-bob/2020/10/18/Solid-Relevance.html)
- [The Wrong Abstraction](https://sandimetz.com/blog/2016/1/20/the-wrong-abstraction)
- [Speculative Generality](https://refactoring.guru/smells/speculative-generality), [Middle Man](https://refactoring.guru/smells/middle-man)
