# Agent Tools

Draft. Every row is a proposal until reviewed.

## Access levels

| Level | Meaning |
|---|---|
| **Read** | Agent can view, never change |
| **Write** | Agent can create and change without asking |
| **Gated** | Agent can prepare the action; a human approves before it runs |
| **Blocked** | Agent never gets access |

## Code and version control

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| git | Branch, commit, diff, history | Write | Force push, history rewrite, push to `main` |
| Code host (GitHub / GitLab) | PRs, reviews, issues | Write | Merge PR, delete branch, change repo settings |

## Run and build

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| Shell | Run commands locally | Write | `rm -rf`, `sudo`, commands outside the repo, global installs (`brew`, `npm -g`, `pipx`), sending data to external URLs (POST, PUT, uploads) |
| just | Run project recipes (`just test`, `just up`) | Write | Changing or removing an existing recipe |
| Package managers (npm, pnpm, pip, …) | Install dependencies | Write | Adding a runtime dependency, upgrading any dependency |
| Test runners | Run tests | Write | Changing or deleting an existing test, changing test config |
| Linters / formatters | Check and fix style | Write | Changing linter or formatter config |
| Docker | Build and run containers locally | Write | Pushing images, `--privileged`, `docker system prune`, editing an existing Dockerfile |
| Docker Compose | Run the local stack for testing | Write | `down -v` (deletes volumes and their data), changing an existing service |

## CI/CD and deploy

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| CI pipelines | Read results, rerun checks | Write | Editing pipeline config |
| Preview deploys | Deploy branches for review | Write | — |
| Staging deploys | Test before production, including migrations | Write | — |
| Production deploys | Ship to users | Gated | Every deploy, rollback, and migration |

## Infrastructure and cloud

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| AWS / GCP / Azure | Compute, storage, networking, IAM | Write without delete in sandbox, Read elsewhere | Any delete; any create, change, or `apply` outside sandbox accounts |
| Cloudflare | Workers, KV, D1, R2, DNS | Write in sandbox, Read elsewhere | Any create, change, delete, or `apply` outside sandbox accounts |
| Databases | Query data | Read | Any direct write or schema change (migrations follow the deploy rules above) |
| Secrets manager | Store credentials | Blocked | — |

## Observability

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| Logs | Debug issues | Read | Reading production logs |
| Error tracking (Sentry, …) | Find and triage errors | Write | Reading production errors, resolving or muting issues |

## Project tracking

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| Linear | Issues, projects, status | Write | Deleting issues, closing projects |
| Notion | Specs, docs, notes | Write | Deleting pages |

## Communication

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| Slack | Read context, post updates | Write | Messages outside agent channels and threads the human started |
| Gmail | Read context, draft replies | Write | Sending any email |
| Google Calendar | Check schedules | Read | Creating or changing events |

## Design

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| Figma | Read designs, comment, implement UI | Write | Editing files |

## Research

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| Web search | Find docs and answers | Read | — |
| Web fetch | Read a specific page | Read | — |
| Browser | Test UI, navigate apps | Write | Logging in anywhere except local and preview apps with test accounts, submitting forms on external sites |

## Agent infrastructure

| Tool | Purpose | Access | Gated actions |
|---|---|---|---|
| MCP servers | Connect external tools | Gated | Adding a server from the approved list |
| Subagents | Split work, run in parallel | Write | — |
| Memory / stores | Keep context across sessions | Write | — |
