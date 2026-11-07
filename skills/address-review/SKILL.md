---
name: address-review
description: Work through review comments on a PR by pushing fixes, replying, and resolving threads. Use when a PR has review comments or the user asks to address, handle, or respond to review feedback.
---

# Address review comments

1. Move the issue to In Progress.
2. Fetch every unresolved review thread on the PR.
3. For each thread:
   - **Valid:** fix it and commit.
   - **Disagree or unclear:** reply with your reasoning or question. Leave the thread open.
4. Push.
5. For each fixed thread, reply with what changed and the commit, then resolve it.
6. When CI passes, move the issue to In Review.
