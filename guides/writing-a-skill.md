# Writing a Skill

A skill is a step-by-step workflow that an agent loads only when a task matches it.

## Policy or skill?

If it applies to every task, it's a policy. If it applies to one language, it's a standard. If it applies to one kind of task, it's a skill.

## Format

Create `skills/<name>/SKILL.md`:

```markdown
---
name: <name>
description: <What it does>. Use when <trigger>.
---

# <Title>

1. First step.
2. Second step.
```

- `name`: lowercase letters, numbers, and hyphens, up to 64 characters. Must match the folder name.
- `description`: one line, up to 1024 characters.

## Rules

- The description decides when the skill loads. Name the task and the words that trigger it.
- Write only what the agent wouldn't already know.
- Use numbered steps, one action per step.
- Stay under 500 lines. Move reference material to a separate file next to `SKILL.md`.
- Link to policies instead of repeating them.

## Team-specific values

When a value differs between teams, don't guess. Write a placeholder the agent fills on first run:

```markdown
- {{ask: <Question>? Replace this line with "<rule using the answer>."}}
```

Run `just validate` before opening a PR.
