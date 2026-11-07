---
name: code-review-surface
description: Build a read-only HTML review board for a PR, organized per package, showing critical code exactly, the rest as pseudocode, and Mermaid diagrams of the flow. Use when a PR touches two or more packages, or when the user asks for a review surface, review board, or package-level review.
---

# Code review surface

## Tiers

Rate every changed unit (function, type, migration, config block). When unsure, go one tier up.

| Tier | Shown as | Covers |
|---|---|---|
| **Critical** | Exact code | Public contracts (exported APIs, interfaces, routes, event schemas), data and schema changes, security (auth, permissions, input validation), money and other irreversible actions, concurrency and transactions, error handling at boundaries, production config |
| **Standard** | Pseudocode | Business logic and orchestration not listed above |
| **Low** | One line | Renames, formatting, imports, generated code, docs, fixtures |

## Accuracy

- Copy code blocks verbatim from the head commit, and link each one to its file and lines at that commit. Never shorten code inside a block; pick a smaller range instead.
- Label pseudocode as pseudocode, write one line per step, and link it to the lines it summarizes.
- List every changed file in the appendix with its tier, so nothing is hidden.
- Draw only what the code supports, and mark new and changed nodes.
- Escape code as HTML. Never include secrets or user data.
- Keep it read-only: no forms and no scripts beyond Mermaid and highlighting. Comments and approval stay in the PR.

## Workflow

1. Get the PR's head commit, base branch, issue link, and full diff.
2. Group changed files by package. Read each package's `README.md` and `CHANGELOG.md`.
3. Rate every changed unit with the tiers above.
4. Draw the overview: a graph of the changed packages and their dependencies. For each package, draw a flowchart or sequence diagram of the main changed flow if it has two or more steps.
5. Write a short list of review questions per package: risks, layer rules, and what the tests do and don't prove.
6. Fill [template.html](template.html) and save it as `.review/<branch>.html`. Add `.review/` to `.git/info/exclude`.
7. Open it in the browser and check that diagrams render, links work, and the appendix lists as many files as `git diff --name-only <base>...HEAD`.
8. Attach the file to the PR, or post its path, with a one-line summary of the critical items.

Without a PR, cover the packages the human names, and rate the code itself instead of the diff.
