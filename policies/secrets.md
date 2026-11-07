# Secrets

- Never print, log, or commit secrets, or paste them into chat, PRs, issues, or messages.
- Never read `.env` files or credential stores unless the task requires it and a human approved.
- Containers get secrets only from an uncommitted `.env` file, never from a Dockerfile or compose file.
- Refer to secrets by name (`DATABASE_URL`), never by value.
- If you find a committed secret, stop and tell the human. Do not rewrite history to remove it.
