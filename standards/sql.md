# SQL and migrations

Baseline: PostgreSQL 18.

## Schema

- Identifiers are lowercase `snake_case`, never quoted. Tables are plural, columns singular, IDs end in `_id`.
- Use `timestamptz`, never `timestamp`.
- Use `text`, or `text` with a `CHECK`. Never `char(n)` or `varchar(n)` with an arbitrary length.
- Primary keys are `bigint GENERATED ALWAYS AS IDENTITY`, or `uuidv7()` for UUIDs. Never `serial`.
- Use `numeric` for money, never `money`.
- Index every foreign key column. PostgreSQL doesn't do it for you.

## Queries

- Use `NOT EXISTS`, never `NOT IN (SELECT …)`. One `NULL` makes `NOT IN` return nothing.
- Use half-open ranges for time: `>= a AND < b`, never `BETWEEN`.
- No `SELECT *` in application code.

## Migrations

- Never edit an applied migration. Fix forward with a new one.
- Every migration works with the app version currently running. Use expand, migrate, contract. A rename is: add the new column, write to both, backfill, switch reads, drop the old one in a later release.
- Drop columns, tables, and constraints only in the contract step, once no deployed code uses them.
- One logical change per migration. Statements that can't run in a transaction get their own file.
- Set `lock_timeout` (about 1s) and `statement_timeout` in every migration.
- Create and drop indexes on existing tables with `CONCURRENTLY`.
- Add a unique constraint by building the unique index concurrently, then `ADD CONSTRAINT … USING INDEX`.
- Add foreign keys and `CHECK` constraints as `NOT VALID`, then `VALIDATE CONSTRAINT` separately.
- Make a column `NOT NULL` without a long lock:

  ```sql
  ALTER TABLE t ADD CONSTRAINT t_c_not_null CHECK (c IS NOT NULL) NOT VALID;
  -- backfill in batches
  ALTER TABLE t VALIDATE CONSTRAINT t_c_not_null;
  ALTER TABLE t ALTER COLUMN c SET NOT NULL;
  ALTER TABLE t DROP CONSTRAINT t_c_not_null;
  ```

- Never change a column type in place unless it's binary compatible (`varchar` to `text`). Add a new column and backfill instead.
- New columns are nullable or have a constant default. Volatile defaults rewrite the table.
- Backfill data in batches, outside DDL migrations.
- Write a `down` migration for every `up`. When a step can't be undone, the `down` file explains why instead of faking it.

## Sources

- [PostgreSQL wiki: Don't Do This](https://wiki.postgresql.org/wiki/Don't_Do_This), [ALTER TABLE](https://www.postgresql.org/docs/current/sql-altertable.html), [CREATE INDEX](https://www.postgresql.org/docs/current/sql-createindex.html)
- [Squawk: safe migrations](https://squawkhq.com/docs/safe_migrations), [GitLab migration style guide](https://docs.gitlab.com/development/migration_style_guide/)
- [Parallel Change](https://martinfowler.com/bliki/ParallelChange.html), [golang-migrate best practices](https://github.com/golang-migrate/migrate/blob/master/MIGRATIONS.md)
- [SQL Style Guide](https://www.sqlstyle.guide/)
