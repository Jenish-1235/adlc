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

This installs ADLC, runs `just doctor`, then lists every gap between the project and the ADLC layout, justfile recipes, and CI stages. Ask your agent to run the `onboard-project` skill to plan and migrate the gaps. Run `just verify ~/code/my-project` to recheck.

`just doctor` checks the tools the project needs (based on what it contains), whether Docker is running, whether `glab` is signed in, and which placeholders are still unanswered.

## First run

Some settings differ between teams, so they ship as `{{ask: ...}}` placeholders. Run `just pending` to list them. Answer them once in this repo, on `main`, with an agent or by hand, then release a version so every project gets the same answers.

## Linear setup

A Linear admin does this once per team:

1. Add the statuses and labels listed in [project-tracking.md](../policies/project-tracking.md). Put Ready for Agent in the Unstarted category, and Needs Input in Started.
2. Turn on the GitLab integration so merged PRs move issues to Done.

Before moving an issue to Ready for Agent, make sure it has:

- a clear goal
- checkable acceptance criteria
- what's out of scope
- links to designs, specs, or related issues

## Versions

An unpinned project follows this clone, so `git pull` here updates it immediately. To roll changes out deliberately, pin it:

```sh
just pin ~/code/my-project v0.1.0
```

This writes `.adlc-version` (commit it so the team shares the pin) and links `.adlc` to that release. To move the pin, read the new sections in [CHANGELOG.md](../CHANGELOG.md) first, then run `just pin` with the new version.

To publish a release, add a `## <version>` section to `CHANGELOG.md`, commit, then run `just release <version>` and push the tag.

## Remove

```sh
just uninstall ~/code/my-project
```
