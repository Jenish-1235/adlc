# Cloud

Applies to AWS, GCP, Azure, Cloudflare, and databases.

- {{ask: Which credentials should agents use for cloud access, e.g. a dedicated read-only role or the developer's own? Replace this line with "Use <answer> for cloud access."}}
- {{ask: Which cloud accounts or projects are sandbox or dev? Replace this line with "Sandbox accounts: <list>."}}
- {{ask: Which infrastructure-as-code tool does the team use, e.g. Terraform, OpenTofu, or Pulumi? Replace this line with "Infrastructure is managed with <answer>."}}
- If you're unsure whether an account is sandbox, treat it as production.
- Confirm the account, project, and region before every command.
- Change infrastructure through code, not the console or CLI. Writing the code and running `plan` are always allowed.
- When asking approval for a change that creates paid resources, include a cost estimate.
