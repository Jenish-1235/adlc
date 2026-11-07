# Cloud

Applies to AWS, GCP, Azure, Cloudflare, and databases.

- Use only the agent identities set up from [iam/](../iam/README.md): `read-only` in staging and production, `write-no-delete` in sandbox. Never use a human's credentials.
- {{ask: Which cloud accounts or projects are sandbox or dev? Replace this line with "Sandbox accounts: <list>."}}
- {{ask: Which infrastructure-as-code tool does the team use, e.g. Terraform, OpenTofu, or Pulumi? Replace this line with "Infrastructure is managed with <answer>."}}
- If you're unsure whether an account is sandbox, treat it as production.
- Confirm the account, project, and region before every command.
- Change infrastructure through code, not the console or CLI. Writing the code and running `plan` are always allowed.
- When asking approval for a change that creates paid resources, include a cost estimate.
