---
name: write-migration
description: Write a safe, backward-compatible PostgreSQL migration. Use when adding or changing tables, columns, indexes, or constraints, or when the user asks for a migration or schema change.
---

# Write a migration

1. Classify the change:
   - **Expand:** add a table, column, index, or constraint.
   - **Migrate:** backfill data or switch reads and writes.
   - **Contract:** drop what no deployed code uses.

   Renames, type changes, drops, and new `NOT NULL` on existing columns need all three phases, in separate releases.
2. Write one logical change per migration, with an up and a down file named the way the project's migration tool expects.
3. Start every migration by setting `lock_timeout` and `statement_timeout`.
4. Use the safe patterns in `.adlc/standards/sql.md`.
5. Run `squawk` on the new files and fix every finding.
6. Run up, down, and up again against the local database (`just up`).
7. Confirm the currently deployed code still works against the new schema.
8. In the PR description, state the phase and what the next phase is. File the next phase with the `create-issue` skill.
