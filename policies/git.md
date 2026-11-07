# Git

- Branch name: `<issue-id>/<short-description>`, e.g. `ENG-123/add-login`. If there is no issue, ask the human for one.
- Never commit to `main`.
- Commit freely on your branch, one logical change per commit.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org): `feat(auth): add login page`.
- Never commit generated files, secrets, or local config.
- Every change goes through a PR. Use the `open-pr` skill.
- {{ask: How are PRs merged: squash, rebase, or merge commit? Replace this line with "PRs are merged with <answer>."}}
- {{ask: Must commits be signed? If yes, replace this line with "Sign every commit. Never use `--no-gpg-sign`." If no, delete this line.}}
- {{ask: Should agent commits credit the agent? If yes, replace this line with "Add a `Co-authored-by` trailer naming the agent to every commit." If no, delete this line.}}
