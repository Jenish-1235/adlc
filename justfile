skill_dirs := ".agents/skills .claude/skills"
pointer := "Follow the team rules in `.adlc/AGENTS.md`."

_default:
    @just --list

# Create a project from a template and install ADLC into it
new template project:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ invocation_directory() }}"
    mkdir "{{ project }}"
    cp -R "{{ justfile_directory() }}/templates/{{ template }}/." "{{ project }}"
    git -C "{{ project }}" init -q
    just --justfile "{{ justfile() }}" install "$(cd "{{ project }}" && pwd)"

# Link ADLC policies and skills into a project
install project:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ invocation_directory() }}"
    cd "{{ project }}"
    exclude=$(git rev-parse --git-path info/exclude)
    add_exclude() { grep -qxF "$1" "$exclude" 2>/dev/null || echo "$1" >> "$exclude"; }
    target="{{ justfile_directory() }}"
    if [ -f .adlc-version ]; then
      version=$(cat .adlc-version)
      target="{{ justfile_directory() }}/.versions/$version"
      [ -d "$target" ] || git -C "{{ justfile_directory() }}" worktree add -q --detach "$target" "$version"
    fi
    ln -sfn "$target" .adlc
    add_exclude .adlc
    for dir in {{ skill_dirs }}; do
      mkdir -p "$dir"
      find "$dir" -maxdepth 1 -type l -lname '../../.adlc/skills/*' -delete
      for skill in .adlc/skills/*/; do
        name=$(basename "$skill")
        ln -sfn "../../.adlc/skills/$name" "$dir/$name"
        add_exclude "$dir/$name"
      done
    done
    grep -qxF '{{ pointer }}' AGENTS.md 2>/dev/null || echo '{{ pointer }}' >> AGENTS.md
    [ -e CLAUDE.md ] || ln -s AGENTS.md CLAUDE.md

# Pin a project to an ADLC release and relink it
pin project version:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ invocation_directory() }}" && cd "{{ project }}"
    echo "{{ version }}" > .adlc-version
    just --justfile "{{ justfile() }}" install .

# Tag an ADLC release once CHANGELOG.md has a section for it
release version:
    #!/usr/bin/env bash
    set -euo pipefail
    [ -z "$(git status --porcelain)" ] || { echo "Commit or stash changes first."; exit 1; }
    grep -qx "## {{ version }}" CHANGELOG.md || { echo "Add a '## {{ version }}' section to CHANGELOG.md first."; exit 1; }
    git tag -a "{{ version }}" -m "ADLC {{ version }}"
    echo "Tagged {{ version }}. Push it with: git push origin {{ version }}"

# List first-run placeholders that still need an answer
pending:
    #!/usr/bin/env bash
    matches=$(grep -rn '{{{{ask:' policies skills)
    [ -z "$matches" ] && { echo "No pending placeholders."; exit 0; }
    echo "$matches" | sed -E 's/^([^:]+:[0-9]+):.*\{\{ask: ([^?]*\?).*/\1  \2/'
    echo "$(echo "$matches" | wc -l | tr -d ' ') placeholders pending."
    exit 1

# Check the tools a project needs before an agent starts work
doctor project=".":
    #!/usr/bin/env bash
    set -uo pipefail
    cd "{{ invocation_directory() }}" && cd "{{ project }}" || exit 1
    problems=0
    need() {
      for tool in $1; do command -v "$tool" >/dev/null && { echo "ok       $tool"; return; }; done
      echo "missing  ${1// / or } ($2)"; problems=1
    }
    need git "version control"
    need just "project recipes"
    need gitleaks "secret scanning in the pre-commit hook"
    [ ! -f .gitlab-ci.yml ] || need glab "GitLab CLI"
    [ ! -f go.mod ] || { need go "Go toolchain"; need golangci-lint "Go lint"; need go-arch-lint "Go layer rules"; }
    [ ! -d migrations ] || need squawk "migration lint"
    [ ! -f package.json ] || { need node "JavaScript runtime"; need pnpm "package manager"; }
    [ ! -d deploy/terraform ] || { need "terraform tofu" "infrastructure"; need tflint "Terraform lint"; }
    [ ! -f deploy/local/docker-compose.yml ] || need docker "local stack"
    if command -v glab >/dev/null && ! glab auth status >/dev/null 2>&1; then echo "signed out glab (run: glab auth login)"; problems=1; fi
    if [ -f deploy/local/docker-compose.yml ] && command -v docker >/dev/null && ! docker info >/dev/null 2>&1; then echo "stopped  docker (start Docker)"; problems=1; fi
    if [ -e .adlc ]; then (cd .adlc && just pending) || problems=1; fi
    exit $problems

# Install ADLC into an existing project, then check its tools and structure
onboard project: (install project)
    #!/usr/bin/env bash
    cd "{{ invocation_directory() }}" && cd "{{ project }}" || exit 1
    just --justfile "{{ justfile() }}" doctor; doctor=$?
    just --justfile "{{ justfile() }}" verify; verify=$?
    exit $(( doctor || verify ))

# Check a project's layout, recipes, and CI stages against the ADLC structure
verify project=".":
    #!/usr/bin/env bash
    set -uo pipefail
    cd "{{ invocation_directory() }}" && cd "{{ project }}" || exit 1
    gaps=0
    gap() { echo "$1"; gaps=1; }
    for path in .gitlab-ci.yml .gitlab/ci.yml .gitlab/ct.yml .gitlab/cd.yml .gitlab/qa.yml .gitlab/loadtest.yml \
                .gitlab/CODEOWNERS deploy/Dockerfile deploy/local/docker-compose.yml \
                deploy/k8s/staging deploy/k8s/prod deploy/terraform/staging deploy/terraform/prod justfile; do
      [ -e "$path" ] || gap "missing: $path"
    done
    [ ! -d migrations ] || [ -e deploy/Dockerfile.db.migrate ] || gap "missing: deploy/Dockerfile.db.migrate"
    packages=$( { find cmd internal -name '*.go' -exec dirname {} \; ; find src deploy -mindepth 1 -maxdepth 1 -type d; } 2>/dev/null | sort -u)
    for dir in $packages; do
      for doc in README.md CHANGELOG.md; do
        [ -e "$dir/$doc" ] || gap "missing: $dir/$doc"
      done
    done
    if [ -f justfile ]; then
      recipes=" $(just --summary 2>/dev/null) "
      for recipe in setup dev test lint up down; do
        [[ "$recipes" == *" $recipe "* ]] || gap "missing: just recipe '$recipe'"
      done
    fi
    if [ -f .gitlab-ci.yml ]; then
      previous=0
      for stage in lint-and-test coverage-and-sast security-and-sbom push sign; do
        line=$(grep -nE "^[[:space:]]*-[[:space:]]*${stage}[[:space:]]*$" .gitlab-ci.yml | head -1 | cut -d: -f1)
        if [ -z "$line" ]; then gap "missing: CI stage '$stage'"
        elif [ "$line" -lt "$previous" ]; then gap "out of order: CI stage '$stage'"
        else previous=$line; fi
      done
    fi
    if [ $gaps -eq 0 ]; then echo "Matches the ADLC structure."; else echo "Ask your agent to run the onboard-project skill."; fi
    exit $gaps

# Remove ADLC links from a project
uninstall project:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ invocation_directory() }}"
    cd "{{ project }}"
    exclude=$(git rev-parse --git-path info/exclude)
    remove_line() {
      if [ -f "$2" ]; then
        grep -vxF "$1" "$2" > "$2.tmp" || true
        mv "$2.tmp" "$2"
      fi
    }
    for skill in .adlc/skills/*/; do
      name=$(basename "$skill")
      for dir in {{ skill_dirs }}; do
        rm -f "$dir/$name"
        remove_line "$dir/$name" "$exclude"
      done
    done
    rm -f .adlc
    remove_line .adlc "$exclude"
    remove_line '{{ pointer }}' AGENTS.md

# Check every skill has a valid name and description
validate:
    #!/usr/bin/env bash
    set -uo pipefail
    status=0
    for file in skills/*/SKILL.md templates/*/.agents/skills/*/SKILL.md; do
      folder=$(basename "$(dirname "$file")")
      name=$(sed -n 's/^name: *//p' "$file" | head -1)
      description=$(sed -n 's/^description: *//p' "$file" | head -1)
      [[ "$name" == "$folder" ]] || { echo "$file: name '$name' must match folder '$folder'"; status=1; }
      [[ "$name" =~ ^[a-z0-9-]{1,64}$ ]] || { echo "$file: name must be lowercase letters, numbers, hyphens, max 64 chars"; status=1; }
      (( ${#description} > 0 && ${#description} <= 1024 )) || { echo "$file: description must be 1-1024 chars"; status=1; }
    done
    exit $status
