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
