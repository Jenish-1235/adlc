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

## First run

Some settings differ between teams, so they ship as `{{ask: ...}}` placeholders. On the first task, the agent asks about each one and writes the answer into this repo. Commit those changes so the whole team shares them.

## Update

Run `git pull` in this repo. Installed projects pick up changes through the links.

## Remove

```sh
just uninstall ~/code/my-project
```
