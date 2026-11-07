# Terraform

Baseline: Terraform 1.17 or OpenTofu 1.13. Never mix OpenTofu-only syntax into Terraform code.

## Layout

- Each environment is its own directory (`deploy/terraform/staging`, `deploy/terraform/prod`) with its own backend, state, and variables.
- Files: `terraform.tf` (versions and providers), `providers.tf`, `backend.tf`, `main.tf`, `variables.tf`, `outputs.tf`. Split `main.tf` only when it's hard to navigate.
- Shared modules live in `modules/<name>`.

## Style

- Run `terraform fmt` and `terraform validate` before every commit.
- Names are `snake_case` nouns that don't repeat the resource type: `aws_instance.web_api`.
- Argument order: `count`/`for_each`, arguments, nested blocks, `lifecycle`, `depends_on`.
- Every variable has a `type` and `description`. Add a `default` only if it's optional.
- Every output has a `description`.
- Comments use `#`, only where the code can't explain itself.

## Modules

- Create a module only when it names a real concept and a second caller exists, such as staging and prod.
- No modules that wrap a single resource.
- Keep the module tree flat.

## Variables

- Expose a variable only if its value differs between environments.
- Pin `required_version` and every provider. Pin registry modules with `version` and git modules with `?ref=`.

## Resources

- Use `for_each` with stable keys when instances differ. Use `count` only for identical copies or a 0/1 toggle.
- Refactor with `moved`, `import`, and `removed` blocks. Never run `state mv` or `state rm` by hand.
- Put `prevent_destroy = true` on stateful production resources: databases, buckets, keys.
- Use `ignore_changes` only for attributes another system owns, with a comment saying which.
- Use `depends_on` only for dependencies Terraform can't see.
- Set shared tags once at the provider level (`default_tags`).

## State and secrets

- Use a remote backend with locking. On S3, use `use_lockfile = true`.
- Commit `.terraform.lock.hcl`. Never commit state, `.terraform/`, plan files, or secret `.tfvars`.
- Secrets never go in `.tf` or `.tfvars`. Use write-only arguments and ephemeral resources so secrets stay out of state.
- `sensitive = true` only hides output. The value is still in state.

## Workflow

- Run `plan -out=tfplan`. Apply exactly that plan file once it's approved.

## Sources

- [Terraform style guide](https://developer.hashicorp.com/terraform/language/style), [Module development](https://developer.hashicorp.com/terraform/language/modules/develop), [Refactoring](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring)
- [Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle), [Write-only arguments](https://developer.hashicorp.com/terraform/language/manage-sensitive-data/write-only), [S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
- [OpenTofu 1.13](https://opentofu.org/blog/opentofu-1-13-0/), [OpenTofu 1.12](https://opentofu.org/blog/opentofu-1-12-0/)
