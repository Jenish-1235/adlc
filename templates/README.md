# Templates

Starting layouts for new projects. Each template is self-contained and ships the same GitLab CI, CODEOWNERS, and `deploy/` layout.

| Template | For |
|---|---|
| `ddd-golang` | Go service with domain-driven design layers |
| `event-driven-golang` | Go service with an API, a worker, and events through an outbox |
| `nextjs` | Next.js app (App Router) |
| `react-vite` | React single-page app built with Vite |

## Use

```sh
just new ddd-golang ~/code/my-service
```

This copies the template, runs `git init`, and installs ADLC into the new project.
