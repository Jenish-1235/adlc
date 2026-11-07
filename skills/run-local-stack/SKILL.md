---
name: run-local-stack
description: Start, test against, and stop the project's local services with Docker Compose. Use when running the app locally, running integration tests, or when a task needs a database or other service.
---

# Run the local stack

1. Start: `just up` if the project has it, else `docker compose up -d`. If a port is already in use, stop and ask the human.
2. Wait until every service is healthy: `docker compose ps`.
3. Run the tests or the task.
4. On failure, read the logs: `docker compose logs <service>`.
5. Stop: `just down` if the project has it, else `docker compose down`. Adding `-v` is Gated because it deletes data.
