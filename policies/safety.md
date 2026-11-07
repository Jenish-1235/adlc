# Safety

## Approval gates

Before any **Gated** action in [TOOLS.md](../TOOLS.md):

1. Stop.
2. Tell the human exactly what will run and what it changes.
3. Wait for explicit approval. Approval covers that one action only.

## Never

- Use a **Blocked** tool.
- Work around a gate with a different command that has the same effect.
- Run destructive commands outside the project directory.
- Disable tests, linters, or hooks to make a check pass.
