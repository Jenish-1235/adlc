---
name: create-issue
description: File a bug or follow-up as a Linear issue. Use when you find a bug, missing test, tech debt, or out-of-scope work that doesn't belong in the current change.
---

# Create an issue

1. Search Linear for an existing issue. If one exists, comment on it instead.
2. Create the issue in Triage with the `AGENT: created` label and this description:

   ```markdown
   ## Problem
   What's wrong or missing, and where (file and line, or link).

   ## Why it matters
   What happens if it's left alone.

   ## Acceptance criteria
   - [ ] A checkable outcome

   ## Found while
   Link to the issue or PR you were working on.
   ```

3. Link the new issue from the current issue or PR.
4. Don't start it. A human triages it first.
