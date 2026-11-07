# Agent cloud access

Each agent gets its own identity per tier. Anything outside a tier's scope is run by a human with their own credentials.

| Tier | Environments | Allows |
|---|---|---|
| `read-only` | staging, production | Resource metadata only. No data reads (objects, rows, logs, queue messages). |
| `write-no-delete` | sandbox | Create and update a fixed set of services. No deletes. |

Always denied in both tiers: reading secret values, decrypting, changing IAM or resource access policies, assuming or impersonating other identities, and billing, account, or org settings.

## AWS

`read-only` uses AWS managed `ViewOnlyAccess` plus `read-only.json`, which only contains explicit denies. `ViewOnlyAccess` grants List/Describe and a few metadata Gets, with no `s3:GetObject`, `ssm:GetParameter`, `secretsmanager:GetSecretValue`, `logs:GetLogEvents`, or `lambda:GetFunction`. `ReadOnlyAccess` grants `s3:Get*`, `ssm:Get*`, `logs:Get*`, `dynamodb:Scan`, and `lambda:Get*`, so it exposes data. `SecurityAudit` grants `rds:DownloadDBLogFilePortion` and `cloudformation:GetTemplate`. The deny file still blocks those actions if someone attaches a broader policy later.

`write-no-delete.json` allows 18 services and denies their `Delete*`, `Terminate*`, `Remove*`, `Deregister*`, `Release*`, `Purge*`, and `Purchase*` actions. A cross-service `*:Delete*` is rejected by IAM Access Analyzer, so the denies are written per service. `iam:PassRole` only works for roles under the path `/agent-sandbox/`, which a human creates.

```sh
aws iam attach-role-policy --role-name agent-read-only --policy-arn arn:aws:iam::aws:policy/job-function/ViewOnlyAccess
aws iam put-role-policy --role-name agent-read-only --policy-name guardrails --policy-document file://iam/aws/read-only.json
aws iam put-role-policy --role-name agent-sandbox --policy-name write-no-delete --policy-document file://iam/aws/write-no-delete.json
```

## GCP

A custom read-only role can't use wildcards and would need thousands of permissions. Instead, grant `roles/reader` and attach `deny-policy.json`. Avoid `roles/viewer`: Viewer is automatically granted BigQuery dataset READER and Cloud Storage convenience-value access, and both expose data. The sandbox agent gets `roles/reader` plus the custom role. Grant `roles/iam.serviceAccountUser` on one runtime service account only, so the agent can deploy Cloud Run or VMs. Creating deny policies needs `roles/iam.denyAdmin`.

```sh
gcloud projects add-iam-policy-binding <project-id> --member=serviceAccount:agent-read-only@<project-id>.iam.gserviceaccount.com --role=roles/reader
gcloud iam roles create agentWriteNoDelete --project=<sandbox-project-id> --file=iam/gcp/write-no-delete.yaml
gcloud iam policies create agent-guardrails --attachment-point=cloudresourcemanager.googleapis.com/projects/<project-id> --kind=denypolicies --policy-file=iam/gcp/deny-policy.json
```

## Azure

`NotActions` only subtracts from that one role; it is not a deny. If the agent also holds Reader or Contributor, the excluded actions come back. Give the agent only these roles. Customer-created deny assignments are in private preview. For hard protection of production, use `CanNotDelete` resource locks or deployment stacks with `--deny-settings-mode denyDelete`.

```sh
az role definition create --role-definition iam/azure/read-only.json
az role definition create --role-definition iam/azure/write-no-delete.json
az role assignment create --assignee <agent-app-id> --role "Agent Read Only" --scope /subscriptions/<subscription-id>
```

## Cloudflare

Tokens only, no policy files. Edit includes delete, so see [cloudflare/README.md](cloudflare/README.md).
