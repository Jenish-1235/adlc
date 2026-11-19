# Changelog

Append-only. Read the sections after your pinned version before moving the pin.

## v0.1.0

- Agent rules, tool access levels, and policies.
- Skills for issues, PRs, CI, review, migrations, upgrades, design, incidents, onboarding, and package docs.
- Language standards for Go, TypeScript, React, Next.js, SQL, and Terraform.
- Project templates with layouts, justfiles, pattern skills, and package docs.
- Least-privilege IAM policies for AWS, GCP, Azure, and Cloudflare.
- `just` recipes: new, onboard, verify, doctor, pending, install, pin, uninstall, release, validate.
- `code-review-surface` skill: a read-only, per-package HTML review board for PRs.
- Templates ship linter configs (golangci-lint, go-arch-lint, ESLint, Squawk, TFLint), a pre-commit hook, and working Vite and Next.js configs.
- Migration timeouts are set on the migration connection, not inside files.

## Unreleased

- `nextjs`, `react-vite` and `ddd-golang` templates run out of the box: working starter code, a sample test, and `just dev` honouring `PORT` and `HOST` (for remote dev machines).
- Next.js and Vite dev servers accept extra host names from `DEV_ALLOWED_HOSTS` (e.g. `devbox,*.devbox`).
- Terraform and migration lint steps run only when the project has `.tf` or migration files; `just up` says so when there are no local services yet.
- `ddd-golang`: `just lint` passes on a fresh copy; `main` logged its exit error without a context, which sloglint rejects.
- Compose examples in every template restart local services after a reboot (`restart: unless-stopped`) until `just down`.
- `python-fastapi` template: FastAPI on uv and Python 3.13 with Ruff, strict mypy, pytest with coverage, JSON logs, `GET /healthz`, a multi-stage non-root Dockerfile, and the `fastapi-patterns` skill. The import package is always `app`; only the project name changes.
- Python standard (`standards/python.md`). `policies/code.md` lists every standard.
- `just doctor` checks for uv in projects with a `pyproject.toml`.
- Each project's local services run as their own compose project, named after the project folder, so two projects' `just up` no longer share containers or data.
