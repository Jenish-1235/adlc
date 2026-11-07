# Project tracking

Issues live in Linear. Docs and specs live in Notion.

## Statuses

| Status | Meaning |
|---|---|
| Triage | New and unsorted |
| Backlog | Accepted, not planned |
| Todo | Planned for a human |
| Ready for Agent | Spec and acceptance criteria are clear; an agent may pick it up |
| In Progress | Someone is working on it |
| Needs Input | Blocked on a human answer or approval |
| In Review | PR open and CI passing |
| Done | Merged |
| Canceled | Won't do, or a duplicate |

## Labels

| Label | Meaning |
|---|---|
| `AGENT: created` | An agent filed this issue |
| `AGENT: proposal` | An agent's improvement idea, waiting for a human to approve or cancel it |
| `AGENT: needs-approval` | In Needs Input, waiting on a Gated action |
| `AGENT: needs-clarification` | In Needs Input, waiting on an answer |
| `AGENT: human-only` | Agents never work on it |
| `AGENT: handed-off` | An agent stopped and a human takes over |

## Rules

- Only start issues in Ready for Agent that don't have `AGENT: human-only`. Use the `start-issue` skill.
- Never move an issue into Ready for Agent, Done, or Canceled. Humans own those.
- When you need a human, move the issue to Needs Input, add the matching label, and comment with the exact question or the exact action awaiting approval. Once answered, remove the label and move it back to In Progress.
- Move an issue to In Review only after its PR is open and CI passes.
- When review requests changes, move the issue to In Progress while you fix them.
- If you can't finish, add `AGENT: handed-off`, comment what you did and where you stopped, and move the issue to Todo.
- File bugs and follow-ups you find with the `create-issue` skill instead of fixing them in the current change.
