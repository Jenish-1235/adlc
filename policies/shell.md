# Shell

- Run `just --list` first. Use a recipe instead of the raw command it wraps.
- If the project has no justfile, create one with the standard recipes the project supports.
- Stop every long-running process you started, such as dev servers, watchers, and containers, before finishing the task.

## Standard recipes

| Recipe | Does |
|---|---|
| `setup` | Install dependencies |
| `dev` | Run the app locally |
| `test` | Run tests |
| `lint` | Check style and types |
| `up` | Start local services |
| `down` | Stop local services |
