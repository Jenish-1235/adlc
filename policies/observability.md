# Observability

- {{ask: Which tools does the team use for logs, errors, and metrics, e.g. Sentry, Datadog, Grafana, CloudWatch? Replace this line with "Logs: <tool>. Errors: <tool>. Metrics: <tool>."}}
- Never copy user data (emails, IDs, payloads) from logs, errors, or databases into chat, PRs, issues, or messages. Summarize instead.
- When adding logging to code:
  - Use structured logs (key-value or JSON).
  - Never log secrets or personal data.
  - Use the right level, and remove debug logs before committing.
  - Add a metric or trace for every new critical path.
