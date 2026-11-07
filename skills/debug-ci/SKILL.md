---
name: debug-ci
description: Find and fix the cause of a failing CI check. Use when a pipeline, build, or check fails on a PR or branch.
---

# Debug CI

1. Get the failing job's logs. Find the first error, not the last.
2. Reproduce locally with the same command CI runs.
3. Classify the failure:
   - **Your change broke it:** fix the code.
   - **Flaky test:** rerun once. If it fails again, treat it as real.
   - **Environment or config:** report to the human. Editing pipeline config is Gated.
4. Push the fix and confirm the check passes.
