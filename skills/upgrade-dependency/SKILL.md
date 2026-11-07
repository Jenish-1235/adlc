---
name: upgrade-dependency
description: Upgrade a dependency, toolchain, base image, or provider version with evidence for approval. Use when updating a package or module, fixing a security advisory, or when the user asks to upgrade or bump a version.
---

# Upgrade a dependency

1. Read the release notes between the current and target versions. List breaking changes and deprecations that affect this project.
2. Run the checks in `.adlc/policies/dependencies.md` on the target version.
3. Ask for approval with the current and target versions, the reason, the breaking changes, and the check results. Upgrades are Gated.
4. Upgrade through the package manager only, one dependency per commit: `build(deps): upgrade <name> to <version>`.
5. Fix breaking changes. For a Go toolchain upgrade, run `go fix ./...`.
6. For a major version, also run the app with `just dev` and test against the local stack.
