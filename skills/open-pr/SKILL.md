---
name: open-pr
description: Prepare and open a pull request following team standards. Use when changes are ready for review or the user asks to open, create, or submit a PR.
---

# Open a PR

1. Review your change with the `review-code` skill.
2. {{ask: Is there a PR size limit? If yes, replace this line with "If the diff exceeds <N> changed lines, propose a split to the human and stop." If no, delete this line.}}
3. Push the branch.
4. Open the PR as ready for review, not draft.
   - Title: a Conventional Commit ending with the issue ID, e.g. `feat(auth): add login page [ENG-123]`.
   - Description:

     ```markdown
     ## What
     One or two sentences on what changed.

     ## Why
     The problem this solves. Link the issue.

     ## How to test
     Steps a reviewer can follow.
     ```

5. If the PR touches two or more packages, build a review surface with the `code-review-surface` skill.
6. When CI passes, move the issue to In Review.
7. Do not merge. Merging is Gated.
