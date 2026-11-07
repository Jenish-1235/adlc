# Adopting ADLC

## Install into a project

```sh
just install ~/code/my-project
```

This adds to the project:

- `.adlc`, a link to this repo
- a link to each skill in `.agents/skills/` and `.claude/skills/`
- a line in `AGENTS.md` pointing agents to `.adlc/AGENTS.md`
- `CLAUDE.md` linked to `AGENTS.md`, if `CLAUDE.md` doesn't exist

The links point to your local clone, so every developer runs `just install` once. They are added to `.git/info/exclude` so they never get committed. The `AGENTS.md` line and `CLAUDE.md` are safe to commit.

## Onboard an existing project

```sh
just onboard ~/code/my-project
```

This installs ADLC, then lists every gap between the project and the ADLC layout, justfile recipes, and CI stages. Ask your agent to run the `onboard-project` skill to plan and migrate the gaps. Run `just verify ~/code/my-project` to recheck.

## First run

Some settings differ between teams, so they ship as `{{ask: ...}}` placeholders. On the first task, the agent asks about each one and writes the answer into this repo. Commit those changes so the whole team shares them.

## Linear setup

A Linear admin does this once per team:

1. Add the statuses and labels listed in [project-tracking.md](../policies/project-tracking.md). Put Ready for Agent in the Unstarted category, and Needs Input in Started.
2. Turn on the GitLab integration so merged PRs move issues to Done.

Before moving an issue to Ready for Agent, make sure it has:

- a clear goal
- checkable acceptance criteria
- what's out of scope
- links to designs, specs, or related issues

## Update

Run `git pull` in this repo. Installed projects pick up changes through the links.

## Remove

```sh
just uninstall ~/code/my-project
```
