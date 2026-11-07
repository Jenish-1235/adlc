---
name: investigate-incident
description: Investigate a production incident and report findings without changing anything. Use when production is down, degraded, or erroring, or the user mentions an incident, outage, or alert.
---

# Investigate an incident

1. Find when it started: the first error or alert.
2. List deploys, config changes, and migrations shortly before that time.
3. Read logs and errors around the start. Find the first failure, not the loudest.
4. Report:

   ```markdown
   ## Impact
   Who and what is affected, and since when.

   ## Likely cause
   The evidence, with links.

   ## Options
   Each fix or rollback, with its risk.
   ```

5. Take no action until the human picks an option.
