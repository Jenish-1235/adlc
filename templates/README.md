# Templates

Starting layouts for new projects. Each template is self-contained and ships:

- the same GitLab CI stages, CODEOWNERS, and `deploy/` layout
- a `justfile` with the standard recipes for its stack
- a `README.md` and `CHANGELOG.md` in every package
- a patterns skill for its architecture

| Template | For | Skill |
|---|---|---|
| `ddd-golang` | Go service with domain-driven design layers | `ddd-patterns` |
| `event-driven-golang` | Go service with an API, a worker, and events through an outbox | `event-driven-patterns` |
| `nextjs` | Next.js app (App Router) | `nextjs-patterns` |
| `react-vite` | React single-page app built with Vite | `react-patterns` |

## Use

```sh
just new ddd-golang ~/code/my-service
```

This copies the template, runs `git init`, and installs ADLC into the new project.
