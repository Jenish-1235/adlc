---
name: continuous-improvement
description: Find evidence-backed improvements to code health, reliability, performance, and UX, and propose them in Linear for humans to approve, then deliver the approved ones. Use when running on a schedule, or when the user asks for ideas, improvements, a UX review, or a tech debt review.
---

# Continuous improvement

## Propose

1. Collect evidence from these sources:
   - **UX:** run the app locally or on preview, walk the main flows in the browser, and note confusing steps, broken states, accessibility issues, and slow pages.
   - **Reliability:** the most frequent errors, slowest endpoints, and flaky tests.
   - **Code health:** `just verify` gaps, lint findings, untested code, outdated dependencies, and code that breaks the standards.
   - **Feedback:** product feedback in Slack and existing issues.
2. Drop ideas that already exist. Search Linear for open issues and for Canceled issues labeled `AGENT: proposal`. A canceled proposal was rejected, so don't propose it again unless the evidence has changed.
3. Rank by impact, then by effort. Keep the top five.
4. For each, create one issue in Triage labeled `AGENT: proposal`:

   ```markdown
   ## Problem
   What's wrong, for whom, and where.

   ## Evidence
   Metrics, screenshots, error links, or quotes.

   ## Proposal
   The smallest change that solves it.

   ## Impact
   What improves, and how we'll know.

   ## Effort
   S, M, or L.

   ## Acceptance criteria
   - [ ] A checkable outcome
   ```

5. Post a summary of the new proposals in an agent channel, with links.
6. Don't build anything. A human approves a proposal by moving it to Ready for Agent.

## Deliver

1. Find proposals in Ready for Agent.
2. Work each one with `start-issue`, then the normal skills through `open-pr`.
3. Once it merges, check the proposal's Impact measure, and comment the result on the issue.
