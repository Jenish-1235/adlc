---
name: update-package-docs
description: Keep each package's README.md and CHANGELOG.md current. Use after changing code in a package, adding a package, or changing how packages depend on each other.
---

# Update package docs

1. For every package your change touches, update `README.md` so it's still true: purpose, Depends on, and Used by.
2. If the change alters behavior, a contract, or a dependency, append to the README's Decisions section:

   ```markdown
   - 2026-11-07: Orders reference customers by ID instead of embedding them, because customers change independently. (ENG-123)
   ```

3. Append one line to `CHANGELOG.md` for each change a user of the package would notice:

   ```markdown
   - 2026-11-07: Add order submission. (ENG-123)
   ```

4. Only append to Decisions and CHANGELOG. Never edit, reorder, or delete past entries.
5. For a new package, create both files in the format below.
6. Commit the docs together with the change they describe.

## Format

```markdown
# <package>

<What it does, and what it deliberately doesn't do.>

## Depends on

- `<package>`: <why>

## Used by

- `<package>`: <for what>

## Decisions
```

```markdown
# Changelog
```
