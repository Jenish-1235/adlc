# ADLC Agent Rules

These rules apply to every task. Tool access levels live in [TOOLS.md](TOOLS.md).

## First run

Search `policies/` and `skills/` for `{{ask:`. For each match, ask the human the question, then edit that line in place as it instructs. Finish this before starting the task.

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
