# ADLC Agent Rules

These rules apply to every task. Tool access levels live in [TOOLS.md](TOOLS.md).

## First run

In a project with a `.adlc` link, finish this before starting the task:

1. Run `just --justfile .adlc/justfile doctor`. Ask the human to install anything it reports missing.
2. Search `.adlc/policies/` and `.adlc/skills/` for `{{ask:`. For each match, ask the human the question, then edit that line in place as it instructs. If the project has an `.adlc-version` file, `.adlc` is a pinned release: don't edit it. Ask the human to answer the placeholders in the ADLC repo and release a new version instead.

## Working on ADLC itself

When the repo root has `templates/` and `skills/` and no `.adlc` link, you're changing the rules for every team:

- Skip First run. Never fill `{{ask:` placeholders.
- Run `just validate` before every commit.
- Append a line to `CHANGELOG.md` for every change teams will notice.

## Always

- Read every policy below before starting a task.
- Stop and ask before any action marked **Gated** in TOOLS.md.
- When researching, use official docs first and cite every source you used.

## Policies

- [Safety](policies/safety.md): approval gates and the never-do list
- [Code](policies/code.md): design principles and which language standard to read
- [Secrets](policies/secrets.md)
- [Shell](policies/shell.md): just recipes and processes
- [Testing](policies/testing.md)
- [Dependencies](policies/dependencies.md)
- [Git](policies/git.md)
- [Code host](policies/code-host.md)
- [CI/CD](policies/ci-cd.md)
- [Cloud](policies/cloud.md)
- [Observability](policies/observability.md)
- [Project tracking](policies/project-tracking.md)
- [Communication](policies/communication.md)
- [Agent infrastructure](policies/agents.md): MCP servers, subagents, memory
