# ADLC

Agentic Development Lifecycle: the team's shared tools, rules, and workflows for building software with AI agents. Works with any tool that reads `AGENTS.md` and Agent Skills, such as Cursor, Claude Code, and Codex.

## Layout

| Path | For | Purpose |
|---|---|---|
| `AGENTS.md` | Agents | Entry point, loaded on every task |
| `TOOLS.md` | Both | Tools agents can use and their access levels |
| `policies/` | Agents | Always-on rules |
| `standards/` | Agents | Language rules, read only for languages a task touches |
| `skills/` | Agents | Step-by-step workflows, loaded when a task matches |
| `guides/` | Humans | How to adopt and extend this repo |
| `templates/` | Humans | Starting layouts for new projects |
| `justfile` | Humans | New project, install, uninstall, and validate |

## Quick start

```sh
just new ddd-golang ~/code/my-service   # new project from a template
just install ~/code/my-project          # existing project
```

See [Adopting ADLC](guides/adopting-adlc.md).

## Skills by lifecycle stage

| Stage | Skills |
|---|---|
| Plan | `start-issue` |
| Build | `implement-design` |
| Test | `run-local-stack`, `debug-ci` |
| Review | `open-pr`, `address-review` |
| Deploy | — |
| Operate | `investigate-incident` |
