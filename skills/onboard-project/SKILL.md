---
name: onboard-project
description: Verify a project against the ADLC layout, justfile recipes, and CI stages, then migrate what doesn't match. Use after `just onboard`, when onboarding an existing project, or when the user asks to check, audit, or migrate a project's structure or CI/CD pipelines.
---

# Onboard a project

## Target structure

- **Layout:** the closest template in `.adlc/templates/`.
- **justfile:** the standard recipes in the shell policy.
- **CI:** `.gitlab-ci.yml` declares the stages below, in order, and includes `.gitlab/*.yml`. CI jobs live in `.gitlab/ci.yml`.

## CI stages

| Stage | Must |
|---|---|
| `lint-and-test` | Run `just lint` and `just test` with coverage, publish the test and coverage reports, and build every image in `deploy/` once, tagged with the commit SHA. |
| `coverage-and-sast` | Run SonarQube on the change and fail when the quality gate fails. |
| `security-and-sbom` | Scan dependencies, images, and the repo for secrets. Generate an SBOM for every image. |
| `push` | Push the images built in `lint-and-test` to each environment's registry, by digest. Never rebuild per environment. |
| `sign` | Sign production images by digest with cosign. Runs for production only. |

CD starts after `sign`.

- {{ask: What coverage must new code reach in the SonarQube quality gate, e.g. 80%? Replace this line with "The quality gate requires at least <N>% coverage on new code."}}
- {{ask: Which vulnerability severity fails the security stage, e.g. high? Replace this line with "The security stage fails on any vulnerability rated <severity> or above."}}

## Workflow

1. Run `just --justfile .adlc/justfile verify .` and note every gap.
2. Pick the closest template. If none fits, ask the human.
3. Compare each existing CI job against the stage table. Note jobs that are missing, in the wrong stage, or not covered by any stage.
4. Write a migration plan listing every file to move, create, or change, and every job to move, add, or remove. Never drop a check. If no stage covers a job, keep it and ask where it belongs.
5. Get approval for the plan. Editing pipeline config is Gated, and approval covers only the changes in the plan.
6. Migrate in this order, one commit each: layout (use `git mv` to keep history), package docs (with the `update-package-docs` skill), justfile recipes, then CI stages.
7. Rerun verify until it passes. Push, and confirm the pipeline passes.
8. Open the PR with the `open-pr` skill. Include the gap list and the plan in the description.
