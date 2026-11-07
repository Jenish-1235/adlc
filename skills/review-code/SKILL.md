---
name: review-code
description: Review your own change against the code policy, language standards, and package docs before opening a PR. Use before `open-pr`, or when the user asks to review, check, or clean up a change.
---

# Review your change

1. Read the full diff against the base branch.
2. For each changed package, reread its `README.md` and the standard for its language.
3. Check every changed line against `.adlc/policies/code.md`. Remove anything that doesn't earn its place: unused code, single-implementation interfaces, forwarding wrappers, defensive checks, and comments that restate the code.
4. Check that every new import matches the package's "Depends on" list and the layer rules.
5. Check that every behavior change has a test, and that every bug fix has a test that failed before the fix.
6. Check that package docs are updated.
7. Remove debug code and changes unrelated to the task.
8. Fix what you find and commit.
